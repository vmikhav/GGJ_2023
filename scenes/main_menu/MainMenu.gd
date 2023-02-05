extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	RenderingServer.set_default_clear_color(Color('EDE8C0'))
	$CanvasLayer/CenterContainer/Play.pressed.connect(start_game)

func start_game():
	get_tree().change_scene_to_file("res://scenes/level/Level.tscn")
