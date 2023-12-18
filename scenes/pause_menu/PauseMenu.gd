extends Control

class_name PauseMenu

signal pressed_exit_button
signal pressed_play_button

@onready var bus_index = AudioServer.get_bus_index("Music")
@onready var sound_slider = $Panel/VBoxContainer/SliderContainer/VBoxContainer2/SoundSlider
@onready var test_sound: AudioStreamPlayer = %TestSoundPlayer as AudioStreamPlayer
@onready var pause_button = %PauseButton as Control
@onready var sound_timer = $Timer as Timer
@export var audio_players: Array[AudioStreamPlayer] = []
var audio_players_statuses: Array[bool] = []

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
	sound_timer.start()
	await sound_timer.timeout
	is_play_sound = true

func _on_pause_manager_toggle_paused(is_paused: bool):
	if is_paused:
		show()
		audio_players_statuses = []
		for i in range(audio_players.size()):
			audio_players_statuses.push_back(audio_players[i].playing)
			audio_players[i].stream_paused = true
	else :
		hide()

func _on_play_pressed():
	PauseManager.game_paused = false
	for i in range(audio_players.size()):
		if audio_players_statuses[i]:
			audio_players[i].stream_paused = false
	pressed_play_button.emit()

func _on_exit_pressed():
	for i in range(audio_players.size()):
		audio_players[i].stop
	PauseManager.game_paused = false
	pressed_exit_button.emit()

func _on_sound_slider_value_changed(value):
	sound_timer.start()
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
			if !Engine.is_editor_hint:
				PauseManager.game_paused = true
