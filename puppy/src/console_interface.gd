class_name ConsoleInterface extends CanvasLayer

var handle := Control.new()
var margins := MarginContainer.new()
var backing := Panel.new()
var vbox := VBoxContainer.new()
var title := Label.new()
var output := RichTextLabel.new()
var status := Label.new()
var input := LineEdit.new()

var title_style := StyleBoxFlat.new()
var output_style := StyleBoxFlat.new()
var status_style := StyleBoxFlat.new()
var input_style := StyleBoxFlat.new()
var backing_style := StyleBoxFlat.new()

var font : Font: set = set_font
var font_size : int: set = set_font_size

var opacity : float: set = set_opacity

const _DEFAULT_VBOX_SEPARATION : int = 0
const _DEFAULT_TITLE : String = "Developer Console"
const _DEFAULT_CONTAINER_MARGINS : Dictionary[String, int] = {
	"margin_left": _DEFAULT_MARGIN_VALUE,
	"margin_right": _DEFAULT_MARGIN_VALUE,
	"margin_top": _DEFAULT_MARGIN_VALUE,
	"margin_bottom": _DEFAULT_MARGIN_VALUE
} 
const _DEFAULT_MARGIN_VALUE : int = 10 
const _DEFAULT_INPUT_PLACEHOLDER_TEXT : String = "Type 'commands' to see all available commands."
const _DEFAULT_FONT : Font = preload("res://puppy/res/DepartureMonoNerdFontMono-Regular.otf")
const _DEFAULT_BORDER_VALUE : int = 1

func _init():
	_init_handle()
	_init_margins()
	_init_backing()
	_init_vbox()
	_init_title()
	_init_output()
	_init_status()
	_init_input()
	
	set_font(_DEFAULT_FONT)
	set_font_size(11)
	
	
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
	_init_backing_style()

func _init_vbox():
	margins.add_child(vbox)
	vbox.add_theme_constant_override("separation", _DEFAULT_BORDER_VALUE)
	
func _init_title():
	vbox.add_child(title)
	title.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	set_title(_DEFAULT_TITLE)
	_init_title_style()

func _init_output():
	vbox.add_child(output)
	output.size_flags_vertical = Control.SIZE_EXPAND_FILL
	output.selection_enabled = true
	output.bbcode_enabled = true
	_init_output_style()

func _init_status():
	vbox.add_child(status)
	_init_status_style()
	
func _init_input():
	vbox.add_child(input)
	input.caret_blink = true
	input.placeholder_text = _DEFAULT_INPUT_PLACEHOLDER_TEXT
	_init_input_style()

func _init_backing_style():
	backing_style.bg_color = Color.CADET_BLUE
	backing_style.set_expand_margin_all(_DEFAULT_BORDER_VALUE)
	backing.add_theme_stylebox_override("panel", backing_style)

func _init_title_style():
	title_style.bg_color = Color.DARK_BLUE
	title.add_theme_stylebox_override("normal", title_style)

func _init_output_style():
	output_style.bg_color = Color.BLACK
	output_style.set_content_margin_all(_DEFAULT_MARGIN_VALUE)
	output.add_theme_stylebox_override("normal", output_style)
	output.add_theme_stylebox_override("focus", StyleBoxEmpty.new())

func _init_status_style():
	status_style.bg_color = Color.DARK_BLUE
	status.add_theme_stylebox_override("normal", status_style)

func _init_input_style():
	input_style.bg_color = Color.BLACK
	input_style.content_margin_left = _DEFAULT_MARGIN_VALUE
	input.add_theme_stylebox_override("normal", input_style)
	input.add_theme_stylebox_override("focus", StyleBoxEmpty.new())

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

func set_bg(color: Color):
	output_style.bg_color = Color(color, 1.0)
	output.add_theme_stylebox_override("normal", output_style)

func set_fg(color: Color):
	output.add_theme_color_override("default_color", Color(color, 1.0))

func set_opacity(value: float):
	output_style.bg_color.a = value
	output.add_theme_stylebox_override("normal", output_style)

func write(text: String): output.text += text
func write_line(text: String): output.text += text + "\n"

func set_container_margins(dictionary: Dictionary):
	for key in dictionary.keys():
		margins.add_theme_constant_override(key, dictionary[key])

func clear_input():
	input.clear()
	input.call_deferred("edit")
