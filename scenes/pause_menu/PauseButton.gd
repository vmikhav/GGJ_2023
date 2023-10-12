extends Button

func _on_pressed():
	PauseManager.game_paused = !PauseManager.game_paused
