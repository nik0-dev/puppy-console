class_name ConsoleInterface extends CanvasLayer

var handle := Control.new()
var margins := MarginContainer.new()
var backing := Panel.new()
var vbox := VBoxContainer.new()
var title := Label.new()
var output := RichTextLabel.new()
var status := Label.new()
var input := LineEdit.new()

var font : Font: set = set_font
var font_size : int: set = set_font_size

const _DEFAULT_VBOX_SEPARATION : int = 0
const _DEFAULT_TITLE : String = "Developer Console"
const _DEFAULT_INPUT_PLACEHOLDER_TEXT : String = "Type 'commands' to see all available commands."
const _DEFAULT_BORDER_VALUE : int = 1
const _DEFAULT_STATUS_FORMATTER = "Working Node: %s | Workspace: %s"
const _DEFAULT_MARGIN_VALUE : int = 10 
const _DEFAULT_CONTAINER_MARGINS : Dictionary[String, int] = {
	"margin_left": _DEFAULT_MARGIN_VALUE,
	"margin_right": _DEFAULT_MARGIN_VALUE,
	"margin_top": _DEFAULT_MARGIN_VALUE,
	"margin_bottom": _DEFAULT_MARGIN_VALUE
} 

func _init():
	_init_handle()
	_init_margins()
	_init_backing()
	_init_vbox()
	_init_title()
	_init_output()
	_init_status()
	_init_input()
	
	set_font(Console.SETTINGS.FONT)
	set_font_size(Console.SETTINGS.FONT_SIZE)
	
func _init_handle():
	add_child(handle)
	handle.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

func _init_margins():
	handle.add_child(margins)
	margins.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	set_container_margins(_DEFAULT_CONTAINER_MARGINS)

func _init_backing():
	margins.add_child(backing)
	backing.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	backing.add_theme_stylebox_override("panel", Console.SETTINGS.BACKING_STYLE)

func _init_vbox():
	margins.add_child(vbox)
	vbox.add_theme_constant_override("separation", _DEFAULT_BORDER_VALUE)
	
func _init_title():
	vbox.add_child(title)
	title.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	set_title(_DEFAULT_TITLE)
	title.add_theme_stylebox_override("normal", Console.SETTINGS.TITLE_STYLE)

func _init_output():
	vbox.add_child(output)
	output.size_flags_vertical = Control.SIZE_EXPAND_FILL
	output.selection_enabled = true
	output.bbcode_enabled = true
	output.shortcut_keys_enabled = false
	output.add_theme_stylebox_override("focus", Console.SETTINGS.OUTPUT_STYLE_FOCUS)
	output.add_theme_stylebox_override("normal", Console.SETTINGS.OUTPUT_STYLE_NORMAL)

func _init_status():
	vbox.add_child(status)
	status.add_theme_stylebox_override("normal", Console.SETTINGS.STATUS_STYLE)
	
func _init_input():
	vbox.add_child(input)
	input.caret_blink = true
	input.caret_blink_interval = 0.2
	input.placeholder_text = _DEFAULT_INPUT_PLACEHOLDER_TEXT
	input.shortcut_keys_enabled = false
	input.context_menu_enabled = false
	input.add_theme_stylebox_override("focus", Console.SETTINGS.INPUT_STYLE_FOCUS)
	input.add_theme_stylebox_override("normal", Console.SETTINGS.INPUT_STYLE_NORMAL)
	
func set_status(text: String): status.text = text
func set_title(text: String): title.text = text

func set_font(new_font: Font):
	title.add_theme_font_override("font", new_font)
	output.add_theme_font_override("normal_font", new_font)
	output.add_theme_font_override("bold_font", new_font)
	output.add_theme_font_override("mono_font", new_font)
	output.add_theme_font_override("italics_font", new_font)
	output.add_theme_font_override("bold_italics_font", new_font)
	status.add_theme_font_override("font", new_font)
	input.add_theme_font_override("font", new_font)
	
func set_font_size(new_font_size: int):
	title.add_theme_font_size_override("font_size", new_font_size)
	title.add_theme_font_size_override("font_size", new_font_size)
	output.add_theme_font_size_override("normal_font_size", new_font_size)
	output.add_theme_font_size_override("bold_font_size", new_font_size)
	output.add_theme_font_size_override("mono_font_size", new_font_size)
	output.add_theme_font_size_override("italics_font_size", new_font_size)
	output.add_theme_font_size_override("bold_italics_font_size", new_font_size)
	status.add_theme_font_size_override("font_size", new_font_size)
	input.add_theme_font_size_override("font_size", new_font_size)
	font_size = new_font_size

func write(text: String): output.text += text
func write_line(text: String): output.text += text + "\n"

func set_container_margins(dictionary: Dictionary):
	for key in dictionary.keys():
		margins.add_theme_constant_override(key, dictionary[key])

func clear_output(): 
	output.text = ""
	
func clear_input():
	input.clear()
	input.call_deferred("edit")

func set_input(text: String):
	input.text = text
	input.call_deferred("edit")
	input.caret_column = input.text.length()
