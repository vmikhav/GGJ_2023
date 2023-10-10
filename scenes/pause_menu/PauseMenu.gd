extends Control

signal pressed_exit_button

@onready var bus_index = AudioServer.get_bus_index("Music")

func  _ready():
	hide()
	PauseManager.connect("toggle_paused", _on_pause_manager_togle_paused)

func _on_pause_manager_togle_paused(is_paused: bool):
	if(is_paused):
		show()
	else :
		hide()


func _on_play_pressed():
	PauseManager.game_paused = false


func _on_exit_pressed():
	emit_signal("pressed_exit_button")
	PauseManager.game_paused = false
	pass


func _on_sound_slider_value_changed(value):
	AudioServer.set_bus_volume_db(bus_index,linear_to_db(value))
