extends Node
class_name PauseManager

signal toggle_paused(is_paused: bool)

var game_paused: bool = false:
	set(value):
		game_paused = value
		get_tree().paused = game_paused
		emit_signal("toggle_paused", game_paused)

func _input(event):
	if (event.is_action_pressed("ui_cancel")):
		game_paused = !game_paused
