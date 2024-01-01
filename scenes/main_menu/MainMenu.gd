extends Node2D

@onready var scene_transaction = $CanvasLayer/SceneTransitionRect
@onready var spinner = $CanvasLayer/CenterContainer2/Spinner
@onready var pause_menu = %PauseMenu as PauseMenu

var mapScene = preload("res://scenes/map/Map.tscn")
var tutorialScene = preload("res://scenes/level/LevelTutorial.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pause_menu.connect("pressed_exit_button", exit_from_pause)
	spinner.pivot_offset = Vector2(130, 130)
	scene_transaction.fade_in()
	RenderingServer.set_default_clear_color(Color('EDE8C0'))
	$CanvasLayer/CenterContainer/MarginContainer/Play.pressed.connect(start_game)
	
	var screen_size = get_tree().get_root().size
	var set_width = ProjectSettings.get("display/window/size/viewport_width")
	var set_height = ProjectSettings.get("display/window/size/viewport_height")
	var ratio = Vector2(screen_size.x, screen_size.y) / Vector2(set_width, set_height)
	var real_width = screen_size.x / ratio.y
	var picture_size = $CanvasLayer/BackgroundRect.size
	if real_width * 1.5 > picture_size.x:
		$CanvasLayer/BackgroundRect.position.x = (-picture_size.x + real_width) / 2
		return
	$CanvasLayer/BackgroundRect.position.x = -picture_size.x + real_width if randf() > 0.5 else 0

	var tween = get_tree().create_tween()
	tween.tween_property(
		$CanvasLayer/BackgroundRect,
		 'position',
		 Vector2((-picture_size.x + real_width) / 2, 0),
		 30
		).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)

func _process(delta):
	spinner.rotation_degrees = spinner.rotation_degrees + 1

func start_game():
	scene_transaction.fade_out()
	$CanvasLayer/CenterContainer2.visible = true
	await get_tree().create_timer(1).timeout
	if PlayerStats.is_tutorial_passed():
		SceneSwitcher.change_scene_to_packed(mapScene)
	else:
		SceneSwitcher.change_scene_to_packed(tutorialScene)

func exit_from_pause():
	get_tree().quit()
