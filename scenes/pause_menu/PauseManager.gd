extends Node

signal toggle_paused(is_paused: bool)
signal toggle_esc(is_paused: bool)

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS

var game_paused: bool = false:
	set(value):
		game_paused = value
		get_tree().paused = game_paused
		emit_signal("toggle_paused", game_paused)

func _input(event: InputEvent):
	if (event.is_action_pressed("ui_cancel")):
		game_paused = !game_paused

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
