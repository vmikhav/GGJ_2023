extends Control

signal pause_button_pressed(is_paused: bool)

func _on_pause_button_pressed() -> void:
	PauseManager.game_paused = !PauseManager.game_paused
	emit_signal("pause_button_pressed", PauseManager.game_paused)
