class_name Console extends Node

#--------------- puppy-console ------------------#
#-- https://github.com/nik0-dev/puppy-console/ --#
#------------------------------------------------#

var interface := ConsoleInterface.new()
var history : Array[String] = []
var history_idx : int = 0
var commands : Dictionary[String, Callable]

var _monitor_timer := Timer.new()
var monitors_visible : bool:
	set(value):
		if value == true:
			restore_state = interface.output.text
			interface.set_status("Working Node: N/A | Workspace: Monitors")
			interface.input.editable = false
			interface.clear_input()
			interface.input.placeholder_text = "Unavailable in Monitors Workspace."
		else:
			interface.output.text = restore_state
			interface.set_status("Working Node: N/A | Workspace: Command Line")
			interface.input.editable = true
			interface.input.call_deferred("grab_focus")
			interface.input.placeholder_text = interface._DEFAULT_INPUT_PLACEHOLDER_TEXT
		monitors_visible = value
		
var restore_state : String = ""

enum Workspace { COMMAND_LINE, MONITORS }

static var SETTINGS : ConsoleSettings = preload("res://puppy/console_settings.tres")

func _enter_tree() -> void:
	add_child(interface)
	
var monitors : Dictionary[String, Callable]

func _ready():
	interface.input.text_submitted.connect(process_command)
	add_child(_monitor_timer)
	
	_monitor_timer.one_shot = false
	_monitor_timer.start(SETTINGS.MONITOR_UPDATE_RATE)
	_monitor_timer.timeout.connect(_monitor_tick)
	
func _monitor_tick():
	if monitors_visible:
		cls()
		for monitor in monitors:
			interface.write_line("%s: %s" % [monitor, monitors[monitor].call()])
	
func _input(event: InputEvent) -> void:
	if !event.is_echo() && event.is_pressed():
		if event.is_match(SETTINGS.HISTORY_NEXT_EVENT):
			pass
		if event.is_match(SETTINGS.HISTORY_PREV_EVENT):
			pass
		if event.is_match(SETTINGS.INCREASE_FONT_SIZE_EVENT):
			interface.font_size += 1
		if event.is_match(SETTINGS.DECREASE_FONT_SIZE_EVENT):
			interface.font_size -= 1
		if event.is_match(SETTINGS.CLEAR_OUTPUT_EVENT):
			interface.clear_output()
		if event.is_match(SETTINGS.TOGGLE_CONSOLE_VISIBILITY_EVENT):
			interface.visible = !interface.visible
		if event.is_match(SETTINGS.RESET_FONT_SIZE_EVENT):
			interface.set_font_size(ConsoleInterface._DEFAULT_FONT_SIZE)
		if event.is_match(SETTINGS.TOGGLE_MONITORS):
			monitors_visible = !monitors_visible
		if event.is_match(SETTINGS.DOCK_LEFT):
			var size = DisplayServer.window_get_size()
			interface.handle.size = Vector2(size.x/2, size.y)
			interface.handle.position = Vector2.ZERO 
		if event.is_match(SETTINGS.DOCK_TOP_LEFT):
			interface.handle.size = DisplayServer.window_get_size() / 2
			interface.handle.position = Vector2.ZERO
		if event.is_match(SETTINGS.DOCK_FULL):
			interface.handle.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
			interface.handle.position = Vector2.ZERO
		if event.is_match(SETTINGS.DOCK_TOP):
			var size = DisplayServer.window_get_size()
			interface.handle.size = Vector2(size.x, size.y/2)
			interface.handle.position = Vector2.ZERO
		if event.is_match(SETTINGS.DOCK_TOP_RIGHT):
			var size = DisplayServer.window_get_size()
			interface.handle.size = Vector2(size.x/2, size.y/2)
			interface.handle.position = Vector2(size.x/2, 0)
		if event.is_match(SETTINGS.DOCK_BOTTOM_LEFT):
			var size = DisplayServer.window_get_size()
			interface.handle.size = Vector2(size.x/2, size.y/2)
			interface.handle.position = Vector2(0, size.y/2)
		if event.is_match(SETTINGS.DOCK_BOTTOM):
			var size = DisplayServer.window_get_size()
			interface.handle.size = Vector2(size.x, size.y/2)
			interface.handle.position = Vector2(0, size.y/2)
		if event.is_match(SETTINGS.DOCK_BOTTOM_RIGHT):
			var size = DisplayServer.window_get_size()
			interface.handle.size = Vector2(size.x/2, size.y/2)
			interface.handle.position = Vector2(size.x/2, size.y/2)
		if event.is_match(SETTINGS.DOCK_RIGHT):
			var size = DisplayServer.window_get_size()
			interface.handle.size = Vector2(size.x/2, size.y)
			interface.handle.position = Vector2(size.x/2, 0)
			
	if event is InputEventKey && event.is_command_or_control_pressed():
		get_viewport().set_input_as_handled()
	
func history_next(): pass
func history_prev(): pass

func create_progress_bar_monitor(progress: Callable, size: Variant = 10):
	var progress_res = progress.call()
	if typeof(progress_res) != TYPE_FLOAT: return "Nil"
	
	var lerp_res : float = lerpf(0, size, progress_res) 
	@warning_ignore("narrowing_conversion")
	return "[%s%s]" % ["#".repeat(lerp_res), ".".repeat(size - floor(lerp_res))]

func cls(): interface.clear_output()

func process_command(command: String):
	interface.write_line(command)
	var argv : Array = command.split(" ", false)
	interface.clear_input()
