class_name ConsoleSettings extends Resource
@export_group("General")

## the rate at which the internal "monitors" update.
## not to be confused with monitor display refresh rates.
## (default rate is 60hz)
@export_range(0.1, 5.0) var MONITOR_UPDATE_RATE : float = 0.167

@export_group("Shortcuts")

@export_subgroup("General")
@export var TOGGLE_CONSOLE_VISIBILITY_EVENT : InputEvent
@export var INCREASE_FONT_SIZE_EVENT : InputEvent
@export var DECREASE_FONT_SIZE_EVENT : InputEvent
@export var RESET_FONT_SIZE_EVENT : InputEvent
@export var TOGGLE_MONITORS : InputEvent

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
