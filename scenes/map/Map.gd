extends Node2D

@onready var map = $TileMap
@onready var ship = $TileMap/Ship
@onready var pause_menu = %PauseMenu as PauseMenu
@onready var audio_stream_player: AudioStreamPlayer = %AudioStreamPlayer
@onready var shop: Control = %Shop
@onready var scene_transaction = $CanvasLayer/SceneTransitionRect
@onready var base_gem = preload("res://sprites/crystal/Crystal.tscn") as PackedScene
var score: int = 0: set = _set_score

# Called when the node enters the scene tree for the first time.
func _ready():
	Respawner.set_scene(self)
	$TouchCamera.target = ship
	map.click.connect(_on_click)
	score = PlayerStats.get_gems()
	var user_position = SceneSwitcher.get_param('respawn_position')
	if !user_position:
		user_position = PlayerStats.get_ship_respawn_pos()
	else:
		PlayerStats.set_ship_respawn_pos(user_position)
	ship.position = user_position
	ship.gem_reward.connect(gem_reward)
	$TouchCamera.position = ship.position	
	scene_transaction.fade_in(1.5)
		
	pause_menu.connect("pressed_exit_button", exit_from_pause)
	var _shops = get_tree().get_nodes_in_group("shop_selector")
	for _shop in _shops:
		_shop.enter_shop.connect(func():
			PauseManager.game_paused = true
			shop.show()
		)
	var _levels = get_tree().get_nodes_in_group("level_selector")
	var _current_level = randi_range(0, _levels.size() - 1)
	for i in _levels.size():
		if i != _current_level:
			_levels[i].queue_free()
	_levels[_current_level].show()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_click(_position: Vector2):
	pass
	#ship.navigate(_position)

func gem_reward(income: int, positions: Vector2):
	for j in range(income):
		var gem = base_gem.instantiate() as Node2D
		gem.position = positions + Vector2(randi_range(-25, 25), randi_range(-25, 25))
		gem.scale = Vector2(0.5, 0.5)
		gem.z_index = 1
		$CanvasLayer.add_child(gem)
		var tween = create_tween()
		var time = randf_range(0.25, 0.75)
		tween.tween_property(gem, 'position', Vector2(60, 60), time)
		tween.parallel().tween_property(gem, 'scale', Vector2(1, 1), time)
		tween.finished.connect(func ():
			gem.queue_free()
			score += 1
		)

func exit_from_pause():
	PlayerStats.save_player_data()
	get_tree().quit()


func _set_score(value):
	score = value
	if value == 0:
		return
	var label = $CanvasLayer/ScoreContainer/MarginContainer/Label as Label
	var coin = $CanvasLayer/ScoreContainer/MarginContainer/Gem as Node2D
	label.pivot_offset.x = label.size.x
	label.pivot_offset.y = label.size.y / 2
	label.text = String.num(score)
	var tween = create_tween()
	tween.tween_property(label, 'scale', Vector2(1.1, 1.1), 0.15)
	tween.parallel().tween_property(coin, 'scale', Vector2(2.3, 2.3), 0.15)
	tween.tween_property(label, 'scale', Vector2(1.0, 1.0), 0.35)
	tween.parallel().tween_property(coin, 'scale', Vector2(2.15, 2.15), 0.35)
