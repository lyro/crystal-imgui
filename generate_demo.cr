unless File.exists? "imgui_demo.cpp"
  `g++ -fpreprocessed -dD -E cimgui/imgui/imgui_demo.cpp > imgui_demo.cpp` # Remove comments

  `clang-tidy imgui_demo.cpp -fix -fix-errors -checks="readability-braces-around-statements,readability-isolate-declaration" -- -Icimgui/imgui`

  `clang-format -i imgui_demo.cpp -style='{ColumnLimit: 0, PointerAlignment: Left, SpacesBeforeTrailingComments: 2, AlignTrailingComments: false, AllowShortFunctionsOnASingleLine: None}'`
end

static_names = Set(String).new

outp = [%(require "./imgui"), %(require "./util"), %(), %(module ImGuiDemo), %(  include ImGui::TopLevel)]

def get_indent(line)
  line.size - line.lstrip.size
end

File.each_line("imgui_demo.cpp") do |fline|
  line = fline.lstrip
  indent = get_indent(fline)
  indent += 2 unless line.empty?

  line = line.gsub(/\bimgui_demo\.cpp\b/, "src/demo.cr")

  guarded_strings = [] of String
  line = line.gsub(/"(.+?)"/) do
    s = $1.gsub(/(\\x[0-9a-f]{2})+/) do
      bytes = $0.scan(/[0-9a-f]{2}/).map do |m|
        m[0].to_u8(16)
      end
      String.new(bytes.to_unsafe.to_slice(bytes.size))
    end
    guarded_strings << s
    %("<STRING#{guarded_strings.size}>")
  end

  if line.starts_with?("#")
    next
  end
  if !line.empty?
    line = line.gsub(/( +|^)\/\/.*/, "")
    next if line.empty?
  end
  line = line.gsub(/(?<=[^%][^%][^%])\b(\d+)f\b/, "\\1f32")
  if line == "{"
    line = "begin"
  elsif line.in?("}", "};")
    line = "end"
  end
  line = line.gsub(/^for \(.+? (\w+) = (0); \1 < ([^& ]+); \1\+\+\) \{$/, "\\3.times do |\\1|")
  line = line.gsub(/^for \(.+? (\w+) = (0); \1 < ([^&]+); \1\+\+\) \{$/, "(\\3).times do |\\1|")
  line = line.gsub(/^for \(.+? (\w+) = (.+); \1 < ([^&]+); \1\+\+\) \{$/, "(\\2...\\3).each do |\\1|")
  line = line.gsub(/^for \(;;\) \{$/, "loop do")
  line = line.gsub(/^case (.+): \{$/, "when \\1 then begin")
  line = line.gsub(/^case (.+):$/, "when \\1")
  line = line.gsub(/^switch \((.+)\) \{$/, "case \\1")
  line = line.gsub(/^(if|while) \((.+)\) \{$/, "\\1 \\2")
  line = line.gsub(/^struct (.+) \{$/, "class \\1")
  line = line.gsub(/^\} else if \((.+)\) \{$/, "elsif \\1")
  line = line.gsub(/^\} else \{$/, "else")

  line = line.gsub(/\B\((unsigned int\*|float|intptr_t)\)/, "")
  line = line.gsub(/\b&/, "")
  line = line.gsub(/&\b([^,) ;]+)/, "pointerof(\\1)")
  line = line.gsub(/->/, ".")
  line = line.gsub(/\.(\w+)/) do
    ".#{$1.underscore}"
  end
  line = line.gsub(/(\w+)\.\b/) do
    "#{$1.underscore}."
  end
  line = line.gsub(/"$/, "\" +")

  line = line.gsub(/\b(Im\w+)_(\w+)\b/, "\\1::\\2")
  line = line.gsub(/\bImVec([24])\(/, "ImVec\\1.new(")

  if line =~ /^char (\w+)\[(\d+)\];$/
    next
  end
  line = line.gsub(/\bchar (\w+)\[(\d+)\] = ""/, "char \\1 = ImGui::TextBuffer.new(\\2)")
  line = line.gsub(/\bchar (\w+)\[(\d+)\] = (".*")/, "char \\1 = ImGui::TextBuffer.new(\\3, \\2)")

  line = line.gsub(/\b(\w+)\b, IM_ARRAYSIZE\(\1\)/, "\\1")
  line = line.gsub(/, ImGuiDataType::\w+,/, ",")

  replaced_static = false
  line = line.gsub(/^static (\w+[^= ]*) (\w+)(\[.*?\]|\*|)( =(( .+);|$)|(\([^a-zA-Z].*\))?;$)/) do
    name = $2
    val = $6? || "#{$1}.new#{$7?}"
    if name.in?("begin", "end")
      name += "_"
    end
    static_names.add(name)
    replaced_static = true
    "static #{name} = #{val.strip}"
  end
  if !replaced_static
    static_names.each do |k|
      line = line.gsub(/(?<![."%])\b#{k}\b/, "#{k}.val")
    end
  end

  line = line.gsub(/^(\w+[^= ]* )?(ImVec[24]) (\w+)\((.+)\);$/, "\\3 = \\2.new(\\4)")
  line = line.gsub(/^(?!static)(const )?(\w+[^= ]* )?(\w+)(\[\d*\]|\*)?? = (.+)$/, "\\3 = \\5")
  line = line.gsub(/^((static )?\w+) = \{(.*)\};?$/, "\\1 = [\\3]")

  line = line.gsub(/^(static )?([^()]+? )?(ImGui::)?(\w+)\((.*?)\) \{$/) do
    args = $5.presence.try &.split(", ").map do |a|
      arg, defa1, defa2 = a.partition(" = ")
      arg.split.last + defa1 + defa2
    end.join(", ")
    static_names.clear
    "def #{"self." if $1? || $3?}#{$4.underscore}(#{args})"
  end
  if line =~ /^static ?(.+? )?(ImGui::)?(\w+)\((.*?)\);$/
    next
  end

  line = line.gsub(/^sprintf\((\w+), (".+?"), (.+)\);$/, "\\1 = sprintf(\\2, \\3)")

  line = line.gsub(/\b([A-Z][a-z]\w*)\(/) do
    "#{$1.underscore}("
  end
  line = line.gsub(/::([a-z])/, ".\\1")

  line = line.gsub(/^\b([\w.]+)(\+|-)\2;/, "\\1 \\2= 1")
  line = line.gsub(", ...", ", *args")

  line = line.gsub(/\b(sin|cos|sqrt)f\(/, "Math.\\1(")
  line = line.gsub(/(\(ImVec4\))?ImColor::HSV\(/, "ImGui.hsv(")
  line = line.gsub(/IM_ARRAYSIZE\((.+?)\)/, "\\1.size")
  line = line.gsub(/IM_MIN\((.+?, .+?)\)/, "{\\1}.min")
  line = line.gsub(/IM_MAX\((.+?, .+?)\)/, "{\\1}.max")
  line = line.gsub(/IM_CLAMP\((.+?), (.+?, .+?)\)/, "\\1.clamp(\\2)")
  line = line.gsub(/IM_COL32\((.+?, .+?, .+?, .+?)\)/, "ImGui.col32(\\1)")
  line = line.gsub(/IM_ASSERT\((.+?)\)/, "assert(\\1)")
  line = line.gsub(/ *IM_FMTARGS\((.+?)\)/, "")
  line = line.gsub(/\bIM_UNICODE_CODEPOINT_MAX\b/, "Char.MAX_CODEPOINT")
  line = line.gsub(/\bNULL\b/, "nil")
  line = line.gsub(/\bFLT_MIN\b/, "Float32::MIN_POSITIVE")
  line = line.gsub(/\bFLT_MAX\b/, "Float32::MAX")
  line = line.gsub(/INT_(MIN|MAX)\b/, "Int32::\\1")
  line = line.gsub(/LLONG_(MIN|MAX)\b/, "Int64::\\1")
  line = line.gsub(/\bIMGUI_VERSION\b/, "ImGui.get_version")
  line = line.gsub(/\bIM_COL32_WHITE\b/, "ImGui.col32(255, 255, 255)")
  line = line.gsub(/\bIMGUI_PAYLOAD_TYPE_/, "ImGui::PAYLOAD_TYPE_")
  line = line.gsub(/" *IM_NEWLINE\b/, "\\n\"")

  line = line.gsub(/\bconst /, "")

  line = line.gsub(/ImGui::(\w+)\(/) do
    "ImGui.#{$1.underscore}("
  end
  line = line.gsub(/^continue;$/, "next")
  line = line.gsub(/;($| +#)/, "\\1")
  line = line.gsub(/\b\(\)/, "")

  guarded_strings.each_with_index do |s, i|
    line = line.sub(%(<STRING#{i + 1}>), s)
  end

  outp << " " * indent + line
end

outp << "end"

outp.each_with_index do |line, i|
  next if line.empty? && ((outp[i - 1] || "").strip.empty? || get_indent(outp.fetch(i - 1, "")) < get_indent(outp.fetch(i + 1, "")))
  puts line
end