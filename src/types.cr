module ImGui
  alias ImDrawCallback = LibImGui::ImDrawCallback
  alias ImDrawIdx = LibImGui::ImDrawIdx
  alias ImFileHandle = LibImGui::ImFileHandle
  alias ImGuiID = LibImGui::ImGuiID
  alias ImGuiInputTextCallback = LibImGui::ImGuiInputTextCallback
  alias ImGuiSizeCallback = LibImGui::ImGuiSizeCallback
  alias ImPoolIdx = LibImGui::ImPoolIdx
  alias ImTextureID = LibImGui::ImTextureID
  alias ImWchar = LibImGui::ImWchar
  alias ImWchar16 = LibImGui::ImWchar16
  alias ImWchar32 = LibImGui::ImWchar32

  @[Extern]
  struct ImVec2
    property x : Float32
    property y : Float32

    def initialize(@x : Float32, @y : Float32)
    end
  end

  alias TopLevel::ImVec2 = ImGui::ImVec2

  @[Extern]
  struct ImVec4
    property x : Float32
    property y : Float32
    property z : Float32
    property w : Float32

    def initialize(@x : Float32, @y : Float32, @z : Float32, @w : Float32)
    end
  end

  alias TopLevel::ImVec4 = ImGui::ImVec4

  # [enum ImGuiWindowFlags_](https://github.com/ocornut/imgui/blob/v1.79/imgui.h#L795)
  @[Flags]
  enum ImGuiWindowFlags
    None = 0
    # Disable title-bar
    NoTitleBar = 1 << 0
    # Disable user resizing with the lower-right grip
    NoResize = 1 << 1
    # Disable user moving the window
    NoMove = 1 << 2
    # Disable scrollbars (window can still scroll with mouse or programmatically)
    NoScrollbar = 1 << 3
    # Disable user vertically scrolling with mouse wheel. On child window, mouse wheel will be forwarded to the parent unless NoScrollbar is also set.
    NoScrollWithMouse = 1 << 4
    # Disable user collapsing window by double-clicking on it
    NoCollapse = 1 << 5
    # Resize every window to its content every frame
    AlwaysAutoResize = 1 << 6
    # Disable drawing background color (WindowBg, etc.) and outside border. Similar as using SetNextWindowBgAlpha(0.0f).
    NoBackground = 1 << 7
    # Never load/save settings in .ini file
    NoSavedSettings = 1 << 8
    # Disable catching mouse, hovering test with pass through.
    NoMouseInputs = 1 << 9
    # Has a menu-bar
    MenuBar = 1 << 10
    # Allow horizontal scrollbar to appear (off by default). You may use SetNextWindowContentSize(ImVec2(width,0.0f)); prior to calling Begin() to specify width. Read code in imgui_demo in the "Horizontal Scrolling" section.
    HorizontalScrollbar = 1 << 11
    # Disable taking focus when transitioning from hidden to visible state
    NoFocusOnAppearing = 1 << 12
    # Disable bringing window to front when taking focus (e.g. clicking on it or programmatically giving it focus)
    NoBringToFrontOnFocus = 1 << 13
    # Always show vertical scrollbar (even if ContentSize.y < Size.y)
    AlwaysVerticalScrollbar = 1 << 14
    # Always show horizontal scrollbar (even if ContentSize.x < Size.x)
    AlwaysHorizontalScrollbar = 1 << 15
    # Ensure child windows without border uses style.WindowPadding (ignored by default for non-bordered child windows, because more convenient)
    AlwaysUseWindowPadding = 1 << 16
    # No gamepad/keyboard navigation within the window
    NoNavInputs = 1 << 18
    # No focusing toward this window with gamepad/keyboard navigation (e.g. skipped by CTRL+TAB)
    NoNavFocus = 1 << 19
    # Append '*' to title without affecting the ID, as a convenience to avoid using the ### operator. When used in a tab/docking context, tab is selected on closure and closure is deferred by one frame to allow code to cancel the closure (with a confirmation popup, etc.) without flicker.
    UnsavedDocument = 1 << 20
    NoNav           = NoNavInputs | NoNavFocus
    NoDecoration    = NoTitleBar | NoResize | NoScrollbar | NoCollapse
    NoInputs        = NoMouseInputs | NoNavInputs | NoNavFocus
    # [BETA] Allow gamepad/keyboard navigation to cross over parent border to this child (only use on child that have no scrolling!)
    NavFlattened = 1 << 23
    # Don't use! For internal use by BeginChild()
    ChildWindow = 1 << 24
    # Don't use! For internal use by BeginTooltip()
    Tooltip = 1 << 25
    # Don't use! For internal use by BeginPopup()
    Popup = 1 << 26
    # Don't use! For internal use by BeginPopupModal()
    Modal = 1 << 27
    # Don't use! For internal use by BeginMenu()
    ChildMenu = 1 << 28
  end
  alias TopLevel::ImGuiWindowFlags = ImGui::ImGuiWindowFlags

  # [enum ImGuiInputTextFlags_](https://github.com/ocornut/imgui/blob/v1.79/imgui.h#L836)
  @[Flags]
  enum ImGuiInputTextFlags
    None = 0
    # Allow 0123456789.+-*/
    CharsDecimal = 1 << 0
    # Allow 0123456789ABCDEFabcdef
    CharsHexadecimal = 1 << 1
    # Turn a..z into A..Z
    CharsUppercase = 1 << 2
    # Filter out spaces, tabs
    CharsNoBlank = 1 << 3
    # Select entire text when first taking mouse focus
    AutoSelectAll = 1 << 4
    # Return 'true' when Enter is pressed (as opposed to every time the value was modified). Consider looking at the IsItemDeactivatedAfterEdit() function.
    EnterReturnsTrue = 1 << 5
    # Callback on pressing TAB (for completion handling)
    CallbackCompletion = 1 << 6
    # Callback on pressing Up/Down arrows (for history handling)
    CallbackHistory = 1 << 7
    # Callback on each iteration. User code may query cursor position, modify text buffer.
    CallbackAlways = 1 << 8
    # Callback on character inputs to replace or discard them. Modify 'EventChar' to replace or discard, or return 1 in callback to discard.
    CallbackCharFilter = 1 << 9
    # Pressing TAB input a '\t' character into the text field
    AllowTabInput = 1 << 10
    # In multi-line mode, unfocus with Enter, add new line with Ctrl+Enter (default is opposite: unfocus with Ctrl+Enter, add line with Enter).
    CtrlEnterForNewLine = 1 << 11
    # Disable following the cursor horizontally
    NoHorizontalScroll = 1 << 12
    # Insert mode
    AlwaysInsertMode = 1 << 13
    # Read-only mode
    ReadOnly = 1 << 14
    # Password mode, display all characters as '*'
    Password = 1 << 15
    # Disable undo/redo. Note that input text owns the text data while active, if you want to provide your own undo/redo stack you need e.g. to call ClearActiveID().
    NoUndoRedo = 1 << 16
    # Allow 0123456789.+-*/eE (Scientific notation input)
    CharsScientific = 1 << 17
    # Callback on buffer capacity changes request (beyond 'buf_size' parameter value), allowing the string to grow. Notify when the string wants to be resized (for string types which hold a cache of their Size). You will be provided a new BufSize in the callback and NEED to honor it. (see misc/cpp/imgui_stdlib.h for an example of using this)
    CallbackResize = 1 << 18
    # Callback on any edit (note that InputText() already returns true on edit, the callback is useful mainly to manipulate the underlying buffer while focus is active)
    CallbackEdit = 1 << 19
    # For internal use by InputTextMultiline()
    Multiline = 1 << 20
    # For internal use by functions using InputText() before reformatting data
    NoMarkEdited = 1 << 21
  end
  alias TopLevel::ImGuiInputTextFlags = ImGui::ImGuiInputTextFlags

  # [enum ImGuiTreeNodeFlags_](https://github.com/ocornut/imgui/blob/v1.79/imgui.h#L865)
  @[Flags]
  enum ImGuiTreeNodeFlags
    None = 0
    # Draw as selected
    Selected = 1 << 0
    # Full colored frame (e.g. for CollapsingHeader)
    Framed = 1 << 1
    # Hit testing to allow subsequent widgets to overlap this one
    AllowItemOverlap = 1 << 2
    # Don't do a TreePush() when open (e.g. for CollapsingHeader) = no extra indent nor pushing on ID stack
    NoTreePushOnOpen = 1 << 3
    # Don't automatically and temporarily open node when Logging is active (by default logging will automatically open tree nodes)
    NoAutoOpenOnLog = 1 << 4
    # Default node to be open
    DefaultOpen = 1 << 5
    # Need double-click to open node
    OpenOnDoubleClick = 1 << 6
    # Only open when clicking on the arrow part. If ImGuiTreeNodeFlags_OpenOnDoubleClick is also set, single-click arrow or double-click all box to open.
    OpenOnArrow = 1 << 7
    # No collapsing, no arrow (use as a convenience for leaf nodes).
    Leaf = 1 << 8
    # Display a bullet instead of arrow
    Bullet = 1 << 9
    # Use FramePadding (even for an unframed text node) to vertically align text baseline to regular widget height. Equivalent to calling AlignTextToFramePadding().
    FramePadding = 1 << 10
    # Extend hit box to the right-most edge, even if not framed. This is not the default in order to allow adding other items on the same line. In the future we may refactor the hit system to be front-to-back, allowing natural overlaps and then this can become the default.
    SpanAvailWidth = 1 << 11
    # Extend hit box to the left-most and right-most edges (bypass the indented area).
    SpanFullWidth = 1 << 12
    # (WIP) Nav: left direction may move to this TreeNode() from any of its child (items submitted between TreeNode and TreePop)
    NavLeftJumpsBackHere = 1 << 13
    CollapsingHeader     = Framed | NoTreePushOnOpen | NoAutoOpenOnLog
  end
  alias TopLevel::ImGuiTreeNodeFlags = ImGui::ImGuiTreeNodeFlags

  # [enum ImGuiPopupFlags_](https://github.com/ocornut/imgui/blob/v1.79/imgui.h#L894)
  @[Flags]
  enum ImGuiPopupFlags
    None = 0
    # For BeginPopupContext*(): open on Left Mouse release. Guaranteed to always be == 0 (same as ImGuiMouseButton_Left)
    MouseButtonLeft = 0
    # For BeginPopupContext*(): open on Right Mouse release. Guaranteed to always be == 1 (same as ImGuiMouseButton_Right)
    MouseButtonRight = 1
    # For BeginPopupContext*(): open on Middle Mouse release. Guaranteed to always be == 2 (same as ImGuiMouseButton_Middle)
    MouseButtonMiddle   =    2
    MouseButtonMask_    = 0x1F
    MouseButtonDefault_ =    1
    # For OpenPopup*(), BeginPopupContext*(): don't open if there's already a popup at the same level of the popup stack
    NoOpenOverExistingPopup = 1 << 5
    # For BeginPopupContextWindow(): don't return true when hovering items, only when hovering empty space
    NoOpenOverItems = 1 << 6
    # For IsPopupOpen(): ignore the ImGuiID parameter and test for any popup.
    AnyPopupId = 1 << 7
    # For IsPopupOpen(): search/test at any level of the popup stack (default test in the current level)
    AnyPopupLevel = 1 << 8
    AnyPopup      = AnyPopupId | AnyPopupLevel
  end
  alias TopLevel::ImGuiPopupFlags = ImGui::ImGuiPopupFlags

  # [enum ImGuiSelectableFlags_](https://github.com/ocornut/imgui/blob/v1.79/imgui.h#L910)
  @[Flags]
  enum ImGuiSelectableFlags
    None = 0
    # Clicking this don't close parent popup window
    DontClosePopups = 1 << 0
    # Selectable frame can span all columns (text will still fit in current column)
    SpanAllColumns = 1 << 1
    # Generate press events on double clicks too
    AllowDoubleClick = 1 << 2
    # Cannot be selected, display grayed out text
    Disabled = 1 << 3
    # (WIP) Hit testing to allow subsequent widgets to overlap this one
    AllowItemOverlap = 1 << 4
  end
  alias TopLevel::ImGuiSelectableFlags = ImGui::ImGuiSelectableFlags

  # [enum ImGuiComboFlags_](https://github.com/ocornut/imgui/blob/v1.79/imgui.h#L921)
  @[Flags]
  enum ImGuiComboFlags
    None = 0
    # Align the popup toward the left by default
    PopupAlignLeft = 1 << 0
    # Max ~4 items visible. Tip: If you want your combo popup to be a specific size you can use SetNextWindowSizeConstraints() prior to calling BeginCombo()
    HeightSmall = 1 << 1
    # Max ~8 items visible (default)
    HeightRegular = 1 << 2
    # Max ~20 items visible
    HeightLarge = 1 << 3
    # As many fitting items as possible
    HeightLargest = 1 << 4
    # Display on the preview box without the square arrow button
    NoArrowButton = 1 << 5
    # Display only a square arrow button
    NoPreview   = 1 << 6
    HeightMask_ = HeightSmall | HeightRegular | HeightLarge | HeightLargest
  end
  alias TopLevel::ImGuiComboFlags = ImGui::ImGuiComboFlags

  # [enum ImGuiTabBarFlags_](https://github.com/ocornut/imgui/blob/v1.79/imgui.h#L935)
  @[Flags]
  enum ImGuiTabBarFlags
    None = 0
    # Allow manually dragging tabs to re-order them + New tabs are appended at the end of list
    Reorderable = 1 << 0
    # Automatically select new tabs when they appear
    AutoSelectNewTabs = 1 << 1
    # Disable buttons to open the tab list popup
    TabListPopupButton = 1 << 2
    # Disable behavior of closing tabs (that are submitted with p_open != NULL) with middle mouse button. You can still repro this behavior on user's side with if (IsItemHovered() && IsMouseClicked(2)) *p_open = false.
    NoCloseWithMiddleMouseButton = 1 << 3
    # Disable scrolling buttons (apply when fitting policy is ImGuiTabBarFlags_FittingPolicyScroll)
    NoTabListScrollingButtons = 1 << 4
    # Disable tooltips when hovering a tab
    NoTooltip = 1 << 5
    # Resize tabs when they don't fit
    FittingPolicyResizeDown = 1 << 6
    # Add scroll buttons when tabs don't fit
    FittingPolicyScroll   = 1 << 7
    FittingPolicyMask_    = FittingPolicyResizeDown | FittingPolicyScroll
    FittingPolicyDefault_ = FittingPolicyResizeDown
  end
  alias TopLevel::ImGuiTabBarFlags = ImGui::ImGuiTabBarFlags

  # [enum ImGuiTabItemFlags_](https://github.com/ocornut/imgui/blob/v1.79/imgui.h#L951)
  @[Flags]
  enum ImGuiTabItemFlags
    None = 0
    # Append '*' to title without affecting the ID, as a convenience to avoid using the ### operator. Also: tab is selected on closure and closure is deferred by one frame to allow code to undo it without flicker.
    UnsavedDocument = 1 << 0
    # Trigger flag to programmatically make the tab selected when calling BeginTabItem()
    SetSelected = 1 << 1
    # Disable behavior of closing tabs (that are submitted with p_open != NULL) with middle mouse button. You can still repro this behavior on user's side with if (IsItemHovered() && IsMouseClicked(2)) *p_open = false.
    NoCloseWithMiddleMouseButton = 1 << 2
    # Don't call PushID(tab->ID)/PopID() on BeginTabItem()/EndTabItem()
    NoPushId = 1 << 3
    # Disable tooltip for the given tab
    NoTooltip = 1 << 4
    # Disable reordering this tab or having another tab cross over this tab
    NoReorder = 1 << 5
    # Enforce the tab position to the left of the tab bar (after the tab list popup button)
    Leading = 1 << 6
    # Enforce the tab position to the right of the tab bar (before the scrolling buttons)
    Trailing = 1 << 7
  end
  alias TopLevel::ImGuiTabItemFlags = ImGui::ImGuiTabItemFlags

  # [enum ImGuiFocusedFlags_](https://github.com/ocornut/imgui/blob/v1.79/imgui.h#L965)
  @[Flags]
  enum ImGuiFocusedFlags
    None = 0
    # IsWindowFocused(): Return true if any children of the window is focused
    ChildWindows = 1 << 0
    # IsWindowFocused(): Test from root window (top most parent of the current hierarchy)
    RootWindow = 1 << 1
    # IsWindowFocused(): Return true if any window is focused. Important: If you are trying to tell how to dispatch your low-level inputs, do NOT use this. Use 'io.WantCaptureMouse' instead! Please read the FAQ!
    AnyWindow           = 1 << 2
    RootAndChildWindows = RootWindow | ChildWindows
  end
  alias TopLevel::ImGuiFocusedFlags = ImGui::ImGuiFocusedFlags

  # [enum ImGuiHoveredFlags_](https://github.com/ocornut/imgui/blob/v1.79/imgui.h#L977)
  @[Flags]
  enum ImGuiHoveredFlags
    # Return true if directly over the item/window, not obstructed by another window, not obstructed by an active popup or modal blocking inputs under them.
    None = 0
    # IsWindowHovered() only: Return true if any children of the window is hovered
    ChildWindows = 1 << 0
    # IsWindowHovered() only: Test from root window (top most parent of the current hierarchy)
    RootWindow = 1 << 1
    # IsWindowHovered() only: Return true if any window is hovered
    AnyWindow = 1 << 2
    # Return true even if a popup window is normally blocking access to this item/window
    AllowWhenBlockedByPopup = 1 << 3
    # Return true even if an active item is blocking access to this item/window. Useful for Drag and Drop patterns.
    AllowWhenBlockedByActiveItem = 1 << 5
    # Return true even if the position is obstructed or overlapped by another window
    AllowWhenOverlapped = 1 << 6
    # Return true even if the item is disabled
    AllowWhenDisabled   = 1 << 7
    RectOnly            = AllowWhenBlockedByPopup | AllowWhenBlockedByActiveItem | AllowWhenOverlapped
    RootAndChildWindows = RootWindow | ChildWindows
  end
  alias TopLevel::ImGuiHoveredFlags = ImGui::ImGuiHoveredFlags

  # [enum ImGuiDragDropFlags_](https://github.com/ocornut/imgui/blob/v1.79/imgui.h#L993)
  @[Flags]
  enum ImGuiDragDropFlags
    None = 0
    # By default, a successful call to BeginDragDropSource opens a tooltip so you can display a preview or description of the source contents. This flag disable this behavior.
    SourceNoPreviewTooltip = 1 << 0
    # By default, when dragging we clear data so that IsItemHovered() will return false, to avoid subsequent user code submitting tooltips. This flag disable this behavior so you can still call IsItemHovered() on the source item.
    SourceNoDisableHover = 1 << 1
    # Disable the behavior that allows to open tree nodes and collapsing header by holding over them while dragging a source item.
    SourceNoHoldToOpenOthers = 1 << 2
    # Allow items such as Text(), Image() that have no unique identifier to be used as drag source, by manufacturing a temporary identifier based on their window-relative position. This is extremely unusual within the dear imgui ecosystem and so we made it explicit.
    SourceAllowNullID = 1 << 3
    # External source (from outside of dear imgui), won't attempt to read current item/window info. Will always return true. Only one Extern source can be active simultaneously.
    SourceExtern = 1 << 4
    # Automatically expire the payload if the source cease to be submitted (otherwise payloads are persisting while being dragged)
    SourceAutoExpirePayload = 1 << 5
    # AcceptDragDropPayload() will returns true even before the mouse button is released. You can then call IsDelivery() to test if the payload needs to be delivered.
    AcceptBeforeDelivery = 1 << 10
    # Do not draw the default highlight rectangle when hovering over target.
    AcceptNoDrawDefaultRect = 1 << 11
    # Request hiding the BeginDragDropSource tooltip from the BeginDragDropTarget site.
    AcceptNoPreviewTooltip = 1 << 12
    # For peeking ahead and inspecting the payload before delivery.
    AcceptPeekOnly = AcceptBeforeDelivery | AcceptNoDrawDefaultRect
  end
  alias TopLevel::ImGuiDragDropFlags = ImGui::ImGuiDragDropFlags

  # [enum ImGuiDataType_](https://github.com/ocornut/imgui/blob/v1.79/imgui.h#L1015)
  enum ImGuiDataType
    # signed char / char (with sensible compilers)
    S8 = 0
    # unsigned char
    U8 = 1
    # short
    S16 = 2
    # unsigned short
    U16 = 3
    # int
    S32 = 4
    # unsigned int
    U32 = 5
    # long long / __int64
    S64 = 6
    # unsigned long long / unsigned __int64
    U64 = 7
    # float
    Float = 8
    # double
    Double = 9
  end
  alias TopLevel::ImGuiDataType = ImGui::ImGuiDataType

  # [enum ImGuiDir_](https://github.com/ocornut/imgui/blob/v1.79/imgui.h#L1031)
  enum ImGuiDir
    None  = -1
    Left  =  0
    Right =  1
    Up    =  2
    Down  =  3
  end
  alias TopLevel::ImGuiDir = ImGui::ImGuiDir

  # [enum ImGuiKey_](https://github.com/ocornut/imgui/blob/v1.79/imgui.h#L1042)
  enum ImGuiKey
    Tab         =  0
    LeftArrow   =  1
    RightArrow  =  2
    UpArrow     =  3
    DownArrow   =  4
    PageUp      =  5
    PageDown    =  6
    Home        =  7
    End         =  8
    Insert      =  9
    Delete      = 10
    Backspace   = 11
    Space       = 12
    Enter       = 13
    Escape      = 14
    KeyPadEnter = 15
    # for text edit CTRL+A: select all
    A = 16
    # for text edit CTRL+C: copy
    C = 17
    # for text edit CTRL+V: paste
    V = 18
    # for text edit CTRL+X: cut
    X = 19
    # for text edit CTRL+Y: redo
    Y = 20
    # for text edit CTRL+Z: undo
    Z = 21
  end
  alias TopLevel::ImGuiKey = ImGui::ImGuiKey

  # [enum ImGuiKeyModFlags_](https://github.com/ocornut/imgui/blob/v1.79/imgui.h#L1070)
  @[Flags]
  enum ImGuiKeyModFlags
    None  = 0
    Ctrl  = 1 << 0
    Shift = 1 << 1
    Alt   = 1 << 2
    Super = 1 << 3
  end
  alias TopLevel::ImGuiKeyModFlags = ImGui::ImGuiKeyModFlags

  # [enum ImGuiNavInput_](https://github.com/ocornut/imgui/blob/v1.79/imgui.h#L1083)
  enum ImGuiNavInput
    # activate / open / toggle / tweak value
    # e.g. Cross  (PS4), A (Xbox), A (Switch), Space (Keyboard)
    Activate = 0
    # cancel / close / exit
    # e.g. Circle (PS4), B (Xbox), B (Switch), Escape (Keyboard)
    Cancel = 1
    # text input / on-screen keyboard
    # e.g. Triang.(PS4), Y (Xbox), X (Switch), Return (Keyboard)
    Input = 2
    # tap: toggle menu / hold: focus, move, resize
    # e.g. Square (PS4), X (Xbox), Y (Switch), Alt (Keyboard)
    Menu = 3
    # move / tweak / resize window (w/ PadMenu)
    # e.g. D-pad Left/Right/Up/Down (Gamepads), Arrow keys (Keyboard)
    DpadLeft  = 4
    DpadRight = 5
    DpadUp    = 6
    DpadDown  = 7
    # scroll / move window (w/ PadMenu)
    # e.g. Left Analog Stick Left/Right/Up/Down
    LStickLeft  =  8
    LStickRight =  9
    LStickUp    = 10
    LStickDown  = 11
    # next window (w/ PadMenu)
    # e.g. L1 or L2 (PS4), LB or LT (Xbox), L or ZL (Switch)
    FocusPrev = 12
    # prev window (w/ PadMenu)
    # e.g. R1 or R2 (PS4), RB or RT (Xbox), R or ZL (Switch)
    FocusNext = 13
    # slower tweaks
    # e.g. L1 or L2 (PS4), LB or LT (Xbox), L or ZL (Switch)
    TweakSlow = 14
    # faster tweaks
    # e.g. R1 or R2 (PS4), RB or RT (Xbox), R or ZL (Switch)
    TweakFast = 15
    # toggle menu
    # = io.KeyAlt
    KeyMenu_ = 16
    # move left
    # = Arrow keys
    KeyLeft_ = 17
    # move right
    KeyRight_ = 18
    # move up
    KeyUp_ = 19
    # move down
    KeyDown_       = 20
    InternalStart_ = KeyMenu_
  end
  alias TopLevel::ImGuiNavInput = ImGui::ImGuiNavInput

  # [enum ImGuiConfigFlags_](https://github.com/ocornut/imgui/blob/v1.79/imgui.h#L1115)
  @[Flags]
  enum ImGuiConfigFlags
    None = 0
    # Master keyboard navigation enable flag. NewFrame() will automatically fill io.NavInputs[] based on io.KeysDown[].
    NavEnableKeyboard = 1 << 0
    # Master gamepad navigation enable flag. This is mostly to instruct your imgui back-end to fill io.NavInputs[]. Back-end also needs to set ImGuiBackendFlags_HasGamepad.
    NavEnableGamepad = 1 << 1
    # Instruct navigation to move the mouse cursor. May be useful on TV/console systems where moving a virtual mouse is awkward. Will update io.MousePos and set io.WantSetMousePos=true. If enabled you MUST honor io.WantSetMousePos requests in your binding, otherwise ImGui will react as if the mouse is jumping around back and forth.
    NavEnableSetMousePos = 1 << 2
    # Instruct navigation to not set the io.WantCaptureKeyboard flag when io.NavActive is set.
    NavNoCaptureKeyboard = 1 << 3
    # Instruct imgui to clear mouse position/buttons in NewFrame(). This allows ignoring the mouse information set by the back-end.
    NoMouse = 1 << 4
    # Instruct back-end to not alter mouse cursor shape and visibility. Use if the back-end cursor changes are interfering with yours and you don't want to use SetMouseCursor() to change mouse cursor. You may want to honor requests from imgui by reading GetMouseCursor() yourself instead.
    NoMouseCursorChange = 1 << 5
    # Application is SRGB-aware.
    IsSRGB = 1 << 20
    # Application is using a touch screen instead of a mouse.
    IsTouchScreen = 1 << 21
  end
  alias TopLevel::ImGuiConfigFlags = ImGui::ImGuiConfigFlags

  # [enum ImGuiBackendFlags_](https://github.com/ocornut/imgui/blob/v1.79/imgui.h#L1131)
  @[Flags]
  enum ImGuiBackendFlags
    None = 0
    # Back-end Platform supports gamepad and currently has one connected.
    HasGamepad = 1 << 0
    # Back-end Platform supports honoring GetMouseCursor() value to change the OS cursor shape.
    HasMouseCursors = 1 << 1
    # Back-end Platform supports io.WantSetMousePos requests to reposition the OS mouse position (only used if ImGuiConfigFlags_NavEnableSetMousePos is set).
    HasSetMousePos = 1 << 2
    # Back-end Renderer supports ImDrawCmd::VtxOffset. This enables output of large meshes (64K+ vertices) while still using 16-bit indices.
    RendererHasVtxOffset = 1 << 3
  end
  alias TopLevel::ImGuiBackendFlags = ImGui::ImGuiBackendFlags

  # [enum ImGuiCol_](https://github.com/ocornut/imgui/blob/v1.79/imgui.h#L1141)
  enum ImGuiCol
    Text         = 0
    TextDisabled = 1
    # Background of normal windows
    WindowBg = 2
    # Background of child windows
    ChildBg = 3
    # Background of popups, menus, tooltips windows
    PopupBg      = 4
    Border       = 5
    BorderShadow = 6
    # Background of checkbox, radio button, plot, slider, text input
    FrameBg              =  7
    FrameBgHovered       =  8
    FrameBgActive        =  9
    TitleBg              = 10
    TitleBgActive        = 11
    TitleBgCollapsed     = 12
    MenuBarBg            = 13
    ScrollbarBg          = 14
    ScrollbarGrab        = 15
    ScrollbarGrabHovered = 16
    ScrollbarGrabActive  = 17
    CheckMark            = 18
    SliderGrab           = 19
    SliderGrabActive     = 20
    Button               = 21
    ButtonHovered        = 22
    ButtonActive         = 23
    # Header* colors are used for CollapsingHeader, TreeNode, Selectable, MenuItem
    Header               = 24
    HeaderHovered        = 25
    HeaderActive         = 26
    Separator            = 27
    SeparatorHovered     = 28
    SeparatorActive      = 29
    ResizeGrip           = 30
    ResizeGripHovered    = 31
    ResizeGripActive     = 32
    Tab                  = 33
    TabHovered           = 34
    TabActive            = 35
    TabUnfocused         = 36
    TabUnfocusedActive   = 37
    PlotLines            = 38
    PlotLinesHovered     = 39
    PlotHistogram        = 40
    PlotHistogramHovered = 41
    TextSelectedBg       = 42
    DragDropTarget       = 43
    # Gamepad/keyboard: current highlighted item
    NavHighlight = 44
    # Highlight window when using CTRL+TAB
    NavWindowingHighlight = 45
    # Darken/colorize entire screen behind the CTRL+TAB window list, when active
    NavWindowingDimBg = 46
    # Darken/colorize entire screen behind a modal window, when one is active
    ModalWindowDimBg = 47
  end
  alias TopLevel::ImGuiCol = ImGui::ImGuiCol

  # [enum ImGuiStyleVar_](https://github.com/ocornut/imgui/blob/v1.79/imgui.h#L1207)
  enum ImGuiStyleVar
    # float     Alpha
    Alpha = 0
    # ImVec2    WindowPadding
    WindowPadding = 1
    # float     WindowRounding
    WindowRounding = 2
    # float     WindowBorderSize
    WindowBorderSize = 3
    # ImVec2    WindowMinSize
    WindowMinSize = 4
    # ImVec2    WindowTitleAlign
    WindowTitleAlign = 5
    # float     ChildRounding
    ChildRounding = 6
    # float     ChildBorderSize
    ChildBorderSize = 7
    # float     PopupRounding
    PopupRounding = 8
    # float     PopupBorderSize
    PopupBorderSize = 9
    # ImVec2    FramePadding
    FramePadding = 10
    # float     FrameRounding
    FrameRounding = 11
    # float     FrameBorderSize
    FrameBorderSize = 12
    # ImVec2    ItemSpacing
    ItemSpacing = 13
    # ImVec2    ItemInnerSpacing
    ItemInnerSpacing = 14
    # float     IndentSpacing
    IndentSpacing = 15
    # float     ScrollbarSize
    ScrollbarSize = 16
    # float     ScrollbarRounding
    ScrollbarRounding = 17
    # float     GrabMinSize
    GrabMinSize = 18
    # float     GrabRounding
    GrabRounding = 19
    # float     TabRounding
    TabRounding = 20
    # ImVec2    ButtonTextAlign
    ButtonTextAlign = 21
    # ImVec2    SelectableTextAlign
    SelectableTextAlign = 22
  end
  alias TopLevel::ImGuiStyleVar = ImGui::ImGuiStyleVar

  # [enum ImGuiButtonFlags_](https://github.com/ocornut/imgui/blob/v1.79/imgui.h#L1242)
  @[Flags]
  enum ImGuiButtonFlags
    None = 0
    # React on left mouse button (default)
    MouseButtonLeft = 1 << 0
    # React on right mouse button
    MouseButtonRight = 1 << 1
    # React on center mouse button
    MouseButtonMiddle   = 1 << 2
    MouseButtonMask_    = MouseButtonLeft | MouseButtonRight | MouseButtonMiddle
    MouseButtonDefault_ = MouseButtonLeft
  end
  alias TopLevel::ImGuiButtonFlags = ImGui::ImGuiButtonFlags

  # [enum ImGuiColorEditFlags_](https://github.com/ocornut/imgui/blob/v1.79/imgui.h#L1255)
  @[Flags]
  enum ImGuiColorEditFlags
    None = 0
    # ColorEdit, ColorPicker, ColorButton: ignore Alpha component (will only read 3 components from the input pointer).
    NoAlpha = 1 << 1
    # ColorEdit: disable picker when clicking on colored square.
    NoPicker = 1 << 2
    # ColorEdit: disable toggling options menu when right-clicking on inputs/small preview.
    NoOptions = 1 << 3
    # ColorEdit, ColorPicker: disable colored square preview next to the inputs. (e.g. to show only the inputs)
    NoSmallPreview = 1 << 4
    # ColorEdit, ColorPicker: disable inputs sliders/text widgets (e.g. to show only the small preview colored square).
    NoInputs = 1 << 5
    # ColorEdit, ColorPicker, ColorButton: disable tooltip when hovering the preview.
    NoTooltip = 1 << 6
    # ColorEdit, ColorPicker: disable display of inline text label (the label is still forwarded to the tooltip and picker).
    NoLabel = 1 << 7
    # ColorPicker: disable bigger color preview on right side of the picker, use small colored square preview instead.
    NoSidePreview = 1 << 8
    # ColorEdit: disable drag and drop target. ColorButton: disable drag and drop source.
    NoDragDrop = 1 << 9
    # ColorButton: disable border (which is enforced by default)
    NoBorder = 1 << 10
    # ColorEdit, ColorPicker: show vertical alpha bar/gradient in picker.
    AlphaBar = 1 << 16
    # ColorEdit, ColorPicker, ColorButton: display preview as a transparent color over a checkerboard, instead of opaque.
    AlphaPreview = 1 << 17
    # ColorEdit, ColorPicker, ColorButton: display half opaque / half checkerboard, instead of opaque.
    AlphaPreviewHalf = 1 << 18
    # (WIP) ColorEdit: Currently only disable 0.0f..1.0f limits in RGBA edition (note: you probably want to use ImGuiColorEditFlags_Float flag as well).
    HDR = 1 << 19
    # [Display]
    # ColorEdit: override _display_ type among RGB/HSV/Hex. ColorPicker: select any combination using one or more of RGB/HSV/Hex.
    DisplayRGB = 1 << 20
    # [Display]
    # "
    DisplayHSV = 1 << 21
    # [Display]
    # "
    DisplayHex = 1 << 22
    # [DataType]
    # ColorEdit, ColorPicker, ColorButton: _display_ values formatted as 0..255.
    Uint8 = 1 << 23
    # [DataType]
    # ColorEdit, ColorPicker, ColorButton: _display_ values formatted as 0.0f..1.0f floats instead of 0..255 integers. No round-trip of value via integers.
    Float = 1 << 24
    # [Picker]
    # ColorPicker: bar for Hue, rectangle for Sat/Value.
    PickerHueBar = 1 << 25
    # [Picker]
    # ColorPicker: wheel for Hue, triangle for Sat/Value.
    PickerHueWheel = 1 << 26
    # [Input]
    # ColorEdit, ColorPicker: input and output data in RGB format.
    InputRGB = 1 << 27
    # [Input]
    # ColorEdit, ColorPicker: input and output data in HSV format.
    InputHSV        = 1 << 28
    OptionsDefault_ = Uint8 | DisplayRGB | InputRGB | PickerHueBar
    DisplayMask_    = DisplayRGB | DisplayHSV | DisplayHex
    DataTypeMask_   = Uint8 | Float
    PickerMask_     = PickerHueWheel | PickerHueBar
    InputMask_      = InputRGB | InputHSV
  end
  alias TopLevel::ImGuiColorEditFlags = ImGui::ImGuiColorEditFlags

  # [enum ImGuiSliderFlags_](https://github.com/ocornut/imgui/blob/v1.79/imgui.h#L1302)
  @[Flags]
  enum ImGuiSliderFlags
    None = 0
    # Clamp value to min/max bounds when input manually with CTRL+Click. By default CTRL+Click allows going out of bounds.
    AlwaysClamp = 1 << 4
    # Make the widget logarithmic (linear otherwise). Consider using ImGuiSliderFlags_NoRoundToFormat with this if using a format-string with small amount of digits.
    Logarithmic = 1 << 5
    # Disable rounding underlying value to match precision of the display format string (e.g. %.3f values are rounded to those 3 digits)
    NoRoundToFormat = 1 << 6
    # Disable CTRL+Click or Enter key allowing to input text directly into the widget
    NoInput = 1 << 7
    # [Internal] We treat using those bits as being potentially a 'float power' argument from the previous API that has got miscast to this enum, and will trigger an assert if needed.
    InvalidMask_ = 0x7000000F
  end
  alias TopLevel::ImGuiSliderFlags = ImGui::ImGuiSliderFlags

  # [enum ImGuiMouseButton_](https://github.com/ocornut/imgui/blob/v1.79/imgui.h#L1319)
  enum ImGuiMouseButton
    Left   = 0
    Right  = 1
    Middle = 2
  end
  alias TopLevel::ImGuiMouseButton = ImGui::ImGuiMouseButton

  # [enum ImGuiMouseCursor_](https://github.com/ocornut/imgui/blob/v1.79/imgui.h#L1329)
  enum ImGuiMouseCursor
    None  = -1
    Arrow =  0
    # When hovering over InputText, etc.
    TextInput = 1
    # (Unused by Dear ImGui functions)
    ResizeAll = 2
    # When hovering over an horizontal border
    ResizeNS = 3
    # When hovering over a vertical border or a column
    ResizeEW = 4
    # When hovering over the bottom-left corner of a window
    ResizeNESW = 5
    # When hovering over the bottom-right corner of a window
    ResizeNWSE = 6
    # (Unused by Dear ImGui functions. Use for e.g. hyperlinks)
    Hand = 7
    # When hovering something with disallowed interaction. Usually a crossed circle.
    NotAllowed = 8
  end
  alias TopLevel::ImGuiMouseCursor = ImGui::ImGuiMouseCursor

  # [enum ImGuiCond_](https://github.com/ocornut/imgui/blob/v1.79/imgui.h#L1352)
  enum ImGuiCond
    # No condition (always set the variable), same as _Always
    None = 0
    # No condition (always set the variable)
    Always = 1 << 0
    # Set the variable once per runtime session (only the first call will succeed)
    Once = 1 << 1
    # Set the variable if the object/window has no persistently saved data (no entry in .ini file)
    FirstUseEver = 1 << 2
    # Set the variable if the object/window is appearing after being hidden/inactive (or the first time)
    Appearing = 1 << 3
  end
  alias TopLevel::ImGuiCond = ImGui::ImGuiCond

  @[Extern]
  struct ImVector
  end

  alias TopLevel::ImVector = ImGui::ImVector

  @[Extern]
  struct ImGuiOnceUponAFrame
    property ref_frame : Int32

    def initialize(@ref_frame : Int32)
    end
  end

  alias TopLevel::ImGuiOnceUponAFrame = ImGui::ImGuiOnceUponAFrame

  @[Extern]
  struct ImGuiStorage
    property data : LibImGui::ImVectorInternal

    def initialize(@data : LibImGui::ImVectorInternal)
    end
  end

  alias TopLevel::ImGuiStorage = ImGui::ImGuiStorage

  @[Extern]
  struct ImGuiListClipper
    property display_start : Int32
    property display_end : Int32
    property items_count : Int32
    property step_no : Int32
    property items_height : Float32
    property start_pos_y : Float32

    def initialize(@display_start : Int32, @display_end : Int32, @items_count : Int32, @step_no : Int32, @items_height : Float32, @start_pos_y : Float32)
    end
  end

  alias TopLevel::ImGuiListClipper = ImGui::ImGuiListClipper

  @[Extern]
  struct ImColor
    property value : ImVec4

    def initialize(@value : ImVec4)
    end
  end

  alias TopLevel::ImColor = ImGui::ImColor

  @[Extern]
  struct ImDrawVert
    property pos : ImVec2
    property uv : ImVec2
    property col : UInt32

    def initialize(@pos : ImVec2, @uv : ImVec2, @col : UInt32)
    end
  end

  alias TopLevel::ImDrawVert = ImGui::ImDrawVert

  @[Extern]
  struct ImDrawChannel
    @_cmd_buffer : LibImGui::ImVectorInternal
    @_idx_buffer : LibImGui::ImVectorInternal

    def initialize(@_cmd_buffer : LibImGui::ImVectorInternal, @_idx_buffer : LibImGui::ImVectorInternal)
    end
  end

  alias TopLevel::ImDrawChannel = ImGui::ImDrawChannel

  # [enum ImDrawCornerFlags_](https://github.com/ocornut/imgui/blob/v1.79/imgui.h#L2062)
  @[Flags]
  enum ImDrawCornerFlags
    None = 0
    # 0x1
    TopLeft = 1 << 0
    # 0x2
    TopRight = 1 << 1
    # 0x4
    BotLeft = 1 << 2
    # 0x8
    BotRight = 1 << 3
    # 0x3
    Top = TopLeft | TopRight
    # 0xC
    Bot = BotLeft | BotRight
    # 0x5
    Left = TopLeft | BotLeft
    # 0xA
    Right = TopRight | BotRight
  end
  alias TopLevel::ImDrawCornerFlags = ImGui::ImDrawCornerFlags

  # [enum ImDrawListFlags_](https://github.com/ocornut/imgui/blob/v1.79/imgui.h#L2078)
  @[Flags]
  enum ImDrawListFlags
    None = 0
    # Enable anti-aliased lines/borders (*2 the number of triangles for 1.0f wide line or lines thin enough to be drawn using textures, otherwise *3 the number of triangles)
    AntiAliasedLines = 1 << 0
    # Enable anti-aliased lines/borders using textures when possible. Require back-end to render with bilinear filtering.
    AntiAliasedLinesUseTex = 1 << 1
    # Enable anti-aliased edge around filled shapes (rounded rectangles, circles).
    AntiAliasedFill = 1 << 2
    # Can emit 'VtxOffset > 0' to allow large meshes. Set when 'ImGuiBackendFlags_RendererHasVtxOffset' is enabled.
    AllowVtxOffset = 1 << 3
  end
  alias TopLevel::ImDrawListFlags = ImGui::ImDrawListFlags

  @[Extern]
  struct ImFontGlyph
    property codepoint : UInt32
    property visible : UInt32
    property advance_x : Float32
    property x0 : Float32
    property y0 : Float32
    property x1 : Float32
    property y1 : Float32
    property u0 : Float32
    property v0 : Float32
    property u1 : Float32
    property v1 : Float32

    def initialize(@codepoint : UInt32, @visible : UInt32, @advance_x : Float32, @x0 : Float32, @y0 : Float32, @x1 : Float32, @y1 : Float32, @u0 : Float32, @v0 : Float32, @u1 : Float32, @v1 : Float32)
    end
  end

  alias TopLevel::ImFontGlyph = ImGui::ImFontGlyph

  @[Extern]
  struct ImFontGlyphRangesBuilder
    property used_chars : LibImGui::ImVectorInternal

    def initialize(@used_chars : LibImGui::ImVectorInternal)
    end
  end

  alias TopLevel::ImFontGlyphRangesBuilder = ImGui::ImFontGlyphRangesBuilder

  # [enum ImFontAtlasFlags_](https://github.com/ocornut/imgui/blob/v1.79/imgui.h#L2300)
  @[Flags]
  enum ImFontAtlasFlags
    None = 0
    # Don't round the height to next power of two
    NoPowerOfTwoHeight = 1 << 0
    # Don't build software mouse cursors into the atlas (save a little texture memory)
    NoMouseCursors = 1 << 1
    # Don't build thick line textures into the atlas (save a little texture memory). The AntiAliasedLinesUseTex features uses them, otherwise they will be rendered using polygons (more expensive for CPU/GPU).
    NoBakedLines = 1 << 2
  end
  alias TopLevel::ImFontAtlasFlags = ImGui::ImFontAtlasFlags
end
