extends Control

@onready var pause_manager: PauseManager
var bus_index

func  _ready():
	hide()
	pause_manager = get_tree().get_first_node_in_group("pause_manager")
	pause_manager.connect("toggle_paused", _on_pause_manager_togle_paused)
	bus_index = AudioServer.get_bus_index("Music")

func _on_pause_manager_togle_paused(is_paused: bool):
	if(is_paused):
		show()
	else :
		hide()


func _on_play_pressed():
	pause_manager.game_paused = false


func _on_exit_pressed():
	get_tree().quit()


func _on_sound_slider_value_changed(value):
	AudioServer.set_bus_volume_db(bus_index,linear_to_db(value))
