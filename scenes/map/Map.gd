extends Node2D

enum Music {
	AMBIENCE, BATTLE
}

@onready var map = $TileMap
@onready var ship = $TileMap/Ship
@onready var pause_menu = %PauseMenu as PauseMenu
@onready var audio_stream_player: AudioStreamPlayer = %AudioStreamPlayer
@onready var audio_stream_player_2: AudioStreamPlayer = %AudioStreamPlayer2
@onready var shop: Control = %Shop
@onready var scene_transaction = $CanvasLayer/SceneTransitionRect
@onready var joystick: VirtualJoystick = $"CanvasLayer/Virtual Joystick"
@onready var base_gem = preload("res://sprites/crystal/Crystal.tscn") as PackedScene
@onready var base_pointer = preload("res://scenes/map/MapPointer.tscn") as PackedScene
@onready var ambience_stream = load_mp3("res://scenes/map/assets/Island_Boogie_V3_Ambient.mp3")
@onready var battle_stream = load_mp3("res://scenes/map/assets/Action 2.mp3")
var score: int = 0: set = _set_score
var playing_stream: Music = Music.AMBIENCE
var stream_tween: Tween

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
	ship.enemy_spooted.connect(func():
		change_music(Music.BATTLE)
	)
	ship.enemy_lost.connect(func():
		change_music(Music.AMBIENCE)
	)
	$TouchCamera.position = ship.position	
	scene_transaction.fade_in(1.5)
		
	pause_menu.connect("pressed_exit_button", exit_from_pause)
	var _shops = get_tree().get_nodes_in_group("shop_selector")
	for _shop in _shops:
		_shop.enter_shop.connect(func():
			joystick._reset()
			PauseManager.game_paused = true
			shop.show()
		)
		add_map_pointer(_shop, MapPointer.PointerType.SHOP)
	var _levels = get_tree().get_nodes_in_group("level_selector")
	var _current_level = randi_range(0, _levels.size() - 1)
	for i in _levels.size():
		if i != _current_level:
			_levels[i].queue_free()
	_levels[_current_level].show()
	_levels[_current_level].enter_level.connect(func():
		joystick._reset()
	)
	add_map_pointer(_levels[_current_level], MapPointer.PointerType.LEVEL)
	
	
	audio_stream_player.stream = ambience_stream
	audio_stream_player_2.stream = battle_stream
	stream_tween = get_tree().create_tween()
	audio_stream_player.volume_db = -60
	audio_stream_player_2.volume_db = -60
	audio_stream_player.play()
	audio_stream_player_2.play()
	audio_stream_player_2.stream_paused = true
	stream_tween.tween_property(audio_stream_player, 'volume_db', -8, 2).set_trans(Tween.TRANS_CIRC)

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


func load_mp3(path: String) -> AudioStreamMP3:
	var file = FileAccess.open(path, FileAccess.READ)
	var sound = AudioStreamMP3.new()
	sound.data = file.get_buffer(file.get_length())
	sound.loop = true
	return sound

func change_music(_new_stream: Music):
	if playing_stream == _new_stream:
		return
	stream_tween.kill()
	var old_stream = audio_stream_player if playing_stream == Music.AMBIENCE else audio_stream_player_2
	var new_stream = audio_stream_player_2 if playing_stream == Music.AMBIENCE else audio_stream_player
	playing_stream = _new_stream
	stream_tween = get_tree().create_tween()
	new_stream.stream_paused = false
	stream_tween.tween_property(old_stream, 'volume_db', -60, 3).set_trans(Tween.TRANS_EXPO)
	stream_tween.parallel().tween_property(new_stream, 'volume_db', -8, 3).set_trans(Tween.TRANS_CIRC)
	stream_tween.tween_callback(func ():
		old_stream.stream_paused = true
	)

func add_map_pointer(_node, _type: MapPointer.PointerType):
	var pointer = base_pointer.instantiate() as MapPointer
	pointer.target_area = _node
	pointer.type = _type
	$TileMap.add_child(pointer)
	var _transform = RemoteTransform2D.new()
	_transform.update_position = true
	_transform.update_rotation = false
	_transform.update_scale = false
	_transform.use_global_coordinates = true
	ship.add_child(_transform)
	_transform.remote_path = pointer.get_path()
