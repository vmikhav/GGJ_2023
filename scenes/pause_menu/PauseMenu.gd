extends Control

signal pressed_exit_button

@onready var bus_index = AudioServer.get_bus_index("Music")
@onready var sound_slider = $Panel/VBoxContainer/SliderContainer/VBoxContainer2/SoundSlider

func  _ready():
	hide()
	PauseManager.connect("toggle_paused", _on_pause_manager_togle_paused)
	var saved_volume = load_volume()
	sound_slider.value = saved_volume
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(saved_volume))

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
	save_volume(value)

func save_volume(volume: float):
	var config = ConfigFile.new()
	config.load("user://config.cfg")
	config.set_value("audio", "volume", volume)
	config.save("user://config.cfg")

func load_volume() -> float:
	var config = ConfigFile.new()
	if config.load("user://config.cfg") == OK:
		return config.get_value("audio", "volume", 0.5)
	return 0.5
