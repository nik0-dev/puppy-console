@icon("res://puppy/res/icons/console_settings.svg")
class_name ConsoleSettings extends Resource

@export_group("General")

## the rate at which the internal "monitors" update.
## not to be confused with monitor display refresh rates.
## (default rate is 60hz)
@export var TITLE : String = "PuppyConsoleGD"
@export_range(0.1, 5.0) var MONITOR_UPDATE_RATE : float = 0.167
@export var FONT : Font = preload("res://puppy/res/fonts/DepartureMonoNerdFontMono-Regular.otf")
@export var FONT_SIZE : int = 11
	
@export_group("Shortcuts")

@export_subgroup("General")
@export var TOGGLE_CONSOLE_VISIBILITY_EVENT : InputEvent
@export var INCREASE_FONT_SIZE_EVENT : InputEvent
@export var DECREASE_FONT_SIZE_EVENT : InputEvent
@export var RESET_FONT_SIZE_EVENT : InputEvent
@export var TOGGLE_MONITORS : InputEvent

@export_subgroup("Docking")
@export var DOCK_TOP_LEFT : InputEvent
@export var DOCK_TOP : InputEvent
@export var DOCK_TOP_RIGHT : InputEvent
@export var DOCK_LEFT : InputEvent
@export var DOCK_FULL : InputEvent
@export var DOCK_RIGHT : InputEvent
@export var DOCK_BOTTOM_LEFT : InputEvent
@export var DOCK_BOTTOM : InputEvent
@export var DOCK_BOTTOM_RIGHT : InputEvent

@export_subgroup("Input")
@export var SELECT_ALL_INPUT_EVENT : InputEvent
@export var CLEAR_INPUT_EVENT : InputEvent
@export var HISTORY_NEXT_EVENT : InputEvent
@export var HISTORY_PREV_EVENT : InputEvent
@export var COPY_INPUT_EVENT : InputEvent
@export var PASTE_INPUT_EVENT : InputEvent
@export var NEXT_WORD_EVENT : InputEvent
@export var PREV_WORD_EVENT : InputEvent
@export var DELETE_LAST_WORD_EVENT : InputEvent
@export var DELETE_NEXT_WORD_EVENT : InputEvent

@export_subgroup("Output")
@export var SELECT_ALL_OUTPUT_EVENT : InputEvent
@export var CLEAR_OUTPUT_EVENT : InputEvent
@export var COPY_OUTPUT_EVENT : InputEvent

@export_group("Styling")

@export_subgroup("General")
@export var MARGIN_TOP : int = 10
@export var MARGIN_RIGHT : int = 10
@export var MARGIN_BOTTOM : int = 10
@export var MARGIN_LEFT : int = 10
@export var VBOX_SEPARATION : int = 0

@export_subgroup("Title")
@export var TITLE_STYLE : StyleBox = preload("res://puppy/res/styles/title.tres")

@export_subgroup("Output")
@export var OUTPUT_STYLE_FOCUS : StyleBox = preload("res://puppy/res/styles/empty.tres")
@export var OUTPUT_STYLE_NORMAL : StyleBox = preload("res://puppy/res/styles/output.tres")

@export_subgroup("Input")
@export var INPUT_STYLE_FOCUS : StyleBox = preload("res://puppy/res/styles/empty.tres")
@export var INPUT_STYLE_NORMAL : StyleBox = preload("res://puppy/res/styles/input.tres")
@export var INPUT_STYLE_READ_ONLY : StyleBox = preload("res://puppy/res/styles/input_read_only.tres")


@export_subgroup("Status")
@export var STATUS_STYLE : StyleBox = preload("res://puppy/res/styles/status.tres")

@export_subgroup("Backing")
@export var BACKING_STYLE : StyleBox = preload("res://puppy/res/styles/backing.tres")

@export_subgroup("Workspace - Command Line")
@export_multiline var CLI_INPUT_HINT : String = "Type 'commands' to see all available commands."

@export_subgroup("Workspace - Monitors")
@export_multiline var MONITOR_INPUT_HINT : String = "Input not allowed in this workspace."
