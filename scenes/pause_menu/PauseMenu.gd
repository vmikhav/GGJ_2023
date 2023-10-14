extends Control

class_name PauseMenu

signal pressed_exit_button

@onready var bus_index = AudioServer.get_bus_index("Music")
@onready var sound_slider = $Panel/VBoxContainer/SliderContainer/VBoxContainer2/SoundSlider
@onready var audio_player: AudioStreamPlayer = %TestSoundPlayer
@onready var test_sound = %TestSoundPlayer as AudioStreamPlayer
@onready var pause_button = %PauseButton as Control
@onready var sound_timer = $Timer as Timer

func  _ready():
	hide()
	PauseManager.connect("toggle_paused", _on_pause_manager_toggle_paused)
	PauseManager.connect("toggle_esc", _on_pause_manager_toggle_paused)
	pause_button.connect("pause_button_pressed", _on_pause_manager_toggle_paused)
	
	var saved_volume = load_volume()
	sound_slider.value = saved_volume
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(saved_volume))
	test_sound.bus = "Music"

func _on_pause_manager_toggle_paused(is_paused: bool):
	if is_paused:
		show()
		audio_player.stream_paused = true
	else :
		hide()
		audio_player.stream_paused = false

func _on_play_pressed():
	PauseManager.game_paused = false
	audio_player.stream_paused = false

func _on_exit_pressed():
	emit_signal("pressed_exit_button")
	PauseManager.game_paused = false
	await get_tree().create_timer(3.0).timeout
	audio_player.stream_paused = false

func _on_sound_slider_value_changed(value):
	AudioServer.set_bus_volume_db(bus_index,linear_to_db(value))
	save_volume(value)
	play_sound()

func play_sound():
	sound_timer.start()
	await sound_timer.timeout
	test_sound.play()
	sound_timer.stop()

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

func _notification(what):
	match what:
		NOTIFICATION_WM_WINDOW_FOCUS_OUT:
			PauseManager.game_paused = true
