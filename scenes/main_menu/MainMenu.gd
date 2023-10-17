extends Node2D

@onready var scene_transaction = $CanvasLayer/SceneTransitionRect
@onready var spinner = $CanvasLayer/CenterContainer2/Spinner

var mapScene = preload("res://scenes/map/Map.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	spinner.pivot_offset = Vector2(130, 130)
	scene_transaction.fade_in()
	RenderingServer.set_default_clear_color(Color('EDE8C0'))
	$CanvasLayer/CenterContainer/Play.pressed.connect(start_game)

func _process(delta):
	spinner.rotation_degrees = spinner.rotation_degrees + 1

func start_game():
	scene_transaction.fade_out()
	$CanvasLayer/CenterContainer2.visible = true
	await get_tree().create_timer(1).timeout
	SceneSwitcher.change_scene_to_packed(mapScene)
