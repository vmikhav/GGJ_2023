extends Node2D

@onready var scene_transaction = $CanvasLayer/SceneTransitionRect
@onready var spinner = $CanvasLayer/CenterContainer2/Spinner

var mapScene = preload("res://scenes/map/Map.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	if randf() > 0.5:
		$CanvasLayer/BackgroundRect.position.x = -2600
	spinner.pivot_offset = Vector2(130, 130)
	scene_transaction.fade_in()
	RenderingServer.set_default_clear_color(Color('EDE8C0'))
	$CanvasLayer/CenterContainer/MarginContainer/Play.pressed.connect(start_game)
	var tween = get_tree().create_tween()
	tween.tween_property(
		$CanvasLayer/BackgroundRect,
		 'position',
		 Vector2(-1450, 0),
		 30
		).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)

func _process(delta):
	spinner.rotation_degrees = spinner.rotation_degrees + 1

func start_game():
	scene_transaction.fade_out()
	$CanvasLayer/CenterContainer2.visible = true
	await get_tree().create_timer(1).timeout
	SceneSwitcher.change_scene_to_packed(mapScene)
