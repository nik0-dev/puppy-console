class_name Console extends Node

#--------------- puppy-console ------------------#
#-- https://github.com/nik0-dev/puppy-console/ --#
#------------------------------------------------#

var interface := ConsoleInterface.new()

func _enter_tree() -> void:
	add_child(interface)
	
func _ready() -> void:
	interface.input.text_submitted.connect(process_command)
	
func process_command(command: String):
	interface.write_line(command)
	interface.clear_input()
