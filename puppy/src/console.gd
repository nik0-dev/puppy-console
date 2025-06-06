class_name Console extends Node

#--------------- puppy-console ------------------#
#-- https://github.com/nik0-dev/puppy-console/ --#
#------------------------------------------------#

var interface := ConsoleInterface.new()

func _enter_tree() -> void:
	add_child(interface)
	
