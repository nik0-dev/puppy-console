class_name Console extends Node

#--------------- puppy-console ------------------#
#-- https://github.com/nik0-dev/puppy-console/ --#
#------------------------------------------------#

var interface := ConsoleInterface.new()

enum Action {
	SELECT_INPUT,
	CLEAR_OUTPUT,
	CLEAR_INPUT,
	TOGGLE_VISIBILITY,
	HISTORY_NEXT,
	HISTORY_PREV
}

const ACTIONS : Dictionary[Action, Key] = {
	Action.SELECT_INPUT: KEY_A,
	Action.CLEAR_OUTPUT: KEY_L,
	Action.CLEAR_INPUT: KEY_X,
	Action.TOGGLE_VISIBILITY: KEY_F7,
	Action.HISTORY_NEXT: KEY_UP,
	Action.HISTORY_PREV: KEY_DOWN
}

func _enter_tree() -> void:
	add_child(interface)

## return type
func test(a: int, b: int) -> void:
	pass
	
func _ready():
	interface.input.text_submitted.connect(process_command)
	
func _input(event: InputEvent) -> void:
	var ctrl_pressed : bool = false
	
	if event is InputEventWithModifiers:
		ctrl_pressed = event.ctrl_pressed 
	
	if event is InputEventKey:
		if !event.is_echo() && event.is_pressed():
			match event.keycode:
				ACTIONS[Action.HISTORY_NEXT]: history_next()
				ACTIONS[Action.HISTORY_PREV]: history_prev()
				ACTIONS[Action.TOGGLE_VISIBILITY]: interface.visible = !interface.visible
			
			if ctrl_pressed:
				match event.keycode:
					ACTIONS[Action.CLEAR_OUTPUT]: cls()
					ACTIONS[Action.CLEAR_INPUT]: interface.clear_input()
					ACTIONS[Action.SELECT_INPUT]: interface.input.select()
				get_viewport().set_input_as_handled()
	
func history_next(): pass
func history_prev(): pass

func cls(): interface.clear_output()
	
func process_command(command: String):
	interface.write_line(command)
	interface.clear_input()
