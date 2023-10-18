extends Control

class_name PauseMenu

signal pressed_exit_button

@onready var bus_index = AudioServer.get_bus_index("Music")
@onready var sound_slider = $Panel/VBoxContainer/SliderContainer/VBoxContainer2/SoundSlider
@onready var audio_player: AudioStreamPlayer = %AudioStreamPlayer
@onready var test_sound = %TestSoundPlayer as AudioStreamPlayer
@onready var pause_button = %PauseButton as Control
@onready var sound_timer = $Timer as Timer

var is_play_sound = false

func  _ready():
	hide()
	PauseManager.connect("toggle_paused", _on_pause_manager_toggle_paused)
	PauseManager.connect("toggle_esc", _on_pause_manager_toggle_paused)
	pause_button.connect("pause_button_pressed", _on_pause_manager_toggle_paused)
	
	var saved_volume = PauseManager.load_volume()
	sound_slider.value = saved_volume
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(saved_volume))
	test_sound.bus = "Music"

func _on_pause_manager_toggle_paused(is_paused: bool):
	if is_paused:
		show()
		audio_player.stream_paused = true
	else :
		hide()

func _on_play_pressed():
	PauseManager.game_paused = false
	audio_player.stream_paused = false

func _on_exit_pressed():
	audio_player.stop()
	PauseManager.game_paused = false
	emit_signal("pressed_exit_button")

func _on_sound_slider_value_changed(value):
	sound_timer.start()
	await sound_timer.timeout
	is_play_sound = true
	if is_play_sound:
		play_test_sound()
	AudioServer.set_bus_volume_db(bus_index,linear_to_db(value))
	PauseManager.save_volume(value)

func play_test_sound():
	await sound_timer.timeout
	test_sound.play()
	sound_timer.stop()

func _notification(what):
	match what:
		NOTIFICATION_WM_WINDOW_FOCUS_OUT:
			PlayerStats.save_player_data()
			PauseManager.game_paused = true
