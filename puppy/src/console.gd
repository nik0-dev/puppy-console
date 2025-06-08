class_name Console extends Node

#--------------- puppy-console ------------------#
#-- https://github.com/nik0-dev/puppy-console/ --#
#------------------------------------------------#

var interface := ConsoleInterface.new()
var history : Array[String] = []
var history_idx : int = 0
var commands : Dictionary[String, Callable]

enum Workspace { COMMAND_LINE, MONITORS }

@onready var working_node : Node = get_tree().root
var current_workspace : Workspace = Workspace.COMMAND_LINE

var _monitor_timer := Timer.new()
var monitors_visible : bool:
	set(value):
		if value == true:
			restore_state = interface.output.text
			interface.set_status(ConsoleInterface._DEFAULT_STATUS_FORMATTER % [
				working_node.name,
				Workspace.keys()[current_workspace]
			])
			interface.input.editable = false
			interface.clear_input()
			interface.input.placeholder_text = "Unavailable in Monitors Workspace."
		else:
			interface.output.text = restore_state
			interface.set_status(ConsoleInterface._DEFAULT_STATUS_FORMATTER % [
				working_node.name,
				Workspace.keys()[current_workspace]
			])
			interface.input.editable = true
			interface.input.call_deferred("grab_focus")
			interface.input.placeholder_text = interface._DEFAULT_INPUT_PLACEHOLDER_TEXT
		monitors_visible = value
		
var restore_state : String = ""

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
	
	monitors["randf"] = create_progress_bar_monitor.bind(func(): return randf(), 30)
	
func _monitor_tick():
	if monitors_visible:
		cls()
		interface.write_line("[center]───── Monitors ─────[/center]\n")
		for monitor in monitors:
			interface.write_line("[center]%s: %s[/center]" % [monitor, monitors[monitor].call()])

func _input(event: InputEvent) -> void:
	if !event.is_echo() && event.is_pressed():
		if interface.output.has_focus():
			if event.is_match(Console.SETTINGS.SELECT_ALL_OUTPUT_EVENT):
				interface.output.select_all()
			if event.is_match(Console.SETTINGS.COPY_OUTPUT_EVENT):
				DisplayServer.clipboard_set(interface.output.get_selected_text())
		if interface.input.has_focus():
			if event.is_match(Console.SETTINGS.CLEAR_INPUT_EVENT):
				interface.clear_input()
			if event.is_match(Console.SETTINGS.SELECT_ALL_INPUT_EVENT):
				interface.input.select()
			if event.is_match(Console.SETTINGS.COPY_INPUT_EVENT):
				if interface.input.has_selection():
					DisplayServer.clipboard_set(interface.input.get_selected_text())
			if event.is_match(Console.SETTINGS.PASTE_INPUT_EVENT):
				if interface.input.has_selection():
					var from = interface.input.get_selection_from_column()
					var to = interface.input.get_selection_to_column()
					interface.input.delete_text(from, to)
					interface.input.deselect()
				interface.input.insert_text_at_caret(DisplayServer.clipboard_get())
			if event.is_match(Console.SETTINGS.NEXT_WORD_EVENT) || event.is_match(Console.SETTINGS.DELETE_NEXT_WORD_EVENT):
				var from : int = interface.input.caret_column
				if !interface.input.text.is_empty():
					if interface.input.caret_column != interface.input.text.length():
						var initial_lookahead = interface.input.text[interface.input.caret_column]
						var initial_pos = interface.input.caret_column 
				
						for i in range(initial_pos, interface.input.text.length()):
							if initial_lookahead == " ":
								if interface.input.text[interface.input.caret_column] != " ": break
							if initial_lookahead != " ":
								if interface.input.text[interface.input.caret_column] == " ": break
							interface.input.caret_column += 1
				var to : int = interface.input.caret_column
				if event.is_match(Console.SETTINGS.DELETE_NEXT_WORD_EVENT): 
					interface.input.delete_text(min(from,to), max(from,to))
							
			if event.is_match(Console.SETTINGS.PREV_WORD_EVENT) || event.is_match(Console.SETTINGS.DELETE_LAST_WORD_EVENT):
				var from : int = interface.input.caret_column
				if !interface.input.text.is_empty():
					if interface.input.caret_column != 0:
						var initial_lookbehind = interface.input.text[interface.input.caret_column - 1]
						var initial_pos = interface.input.caret_column 
				
						for i in range(initial_pos, -1, -1):
							if initial_lookbehind == " ":
								if interface.input.text[interface.input.caret_column - 1] != " ": break
							if initial_lookbehind != " ":
								if interface.input.text[interface.input.caret_column - 1] == " ": break
							interface.input.caret_column -= 1
				var to : int = interface.input.caret_column
				if event.is_match(Console.SETTINGS.DELETE_LAST_WORD_EVENT): 
					interface.input.delete_text(min(from,to), max(from,to))
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
			interface.set_font_size(SETTINGS.FONT_SIZE)
		if event.is_match(SETTINGS.TOGGLE_MONITORS):
			monitors_visible = !monitors_visible
		if event.is_match(SETTINGS.DOCK_LEFT):
			var size = DisplayServer.window_get_size()
			interface.handle.size = Vector2(size.x/2, size.y) 
			interface.handle.position = Vector2.ZERO
		if event.is_match(SETTINGS.DOCK_TOP_LEFT):
			var size = DisplayServer.window_get_size()
			interface.handle.size = Vector2(size.x/2, size.y/2) 
			interface.handle.position = Vector2.ZERO
		if event.is_match(SETTINGS.DOCK_TOP):
			var size = DisplayServer.window_get_size()
			interface.handle.size = Vector2(size.x, size.y/2) 
			interface.handle.position = Vector2.ZERO
		if event.is_match(SETTINGS.DOCK_RIGHT):
			var size = DisplayServer.window_get_size()
			interface.handle.size = Vector2(size.x/2, size.y) 
			interface.handle.position = Vector2(size.x/2, 0)
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
		if event.is_match(SETTINGS.DOCK_FULL):
			interface.handle.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
			
	if event is InputEventKey && event.is_command_or_control_pressed():
		get_viewport().set_input_as_handled()
	
func history_next(): pass
func history_prev(): pass

func create_progress_bar_monitor(progress: Callable, size: Variant = 10):
	var progress_res = progress.call()
	if typeof(progress_res) != TYPE_FLOAT: return "Nil"
	
	var lerp_res : float = lerpf(0, size, progress_res) 
	@warning_ignore("narrowing_conversion")
	return "[bgcolor=gray][color=black][%s%s][/color][/bgcolor]" % ["#".repeat(lerp_res), ".".repeat(size - floor(lerp_res))]

func cls(): interface.clear_output()

func process_command(command: String):
	interface.write_line(command)
	var argv : Array = command.split(" ", false)
	
	interface.write_line("argv: " + str(argv))
	interface.write_line("argt: " + str(argv.map(func(v): return type_string(typeof(str_to_var(v))))))
	interface.clear_input()
