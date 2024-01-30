extends Node2D

var last_tile_pos: int = 3
var last_tile_real_pos: Vector2 = Vector2(500, -1000)
var world_tile_width: int = 7
var last_tile_orientation: Tile.ORIENTATION = Tile.ORIENTATION.LEFT_UP 

@onready var pause_menu = %PauseMenu as PauseMenu
@onready var base_tile = preload("res://sprites/tile/Tile.tscn") as PackedScene
@onready var character = $Character as Node2D
@onready var recognizer = $Recognizer as Recognizer
@onready var scene_transaction = $DrawerLayer/SceneTransitionRect
@onready var audio_stream_player: AudioStreamPlayer = %AudioStreamPlayer

var last_tile: Tile
var difficulty = 0.15
var total_tiles_count = 0
var tiles_without_obstacles = 0
var obstacles_in_row = 0
var max_obstacles_in_row = 2
var to_next_obstacle = 0
var can_remove_tiles = true
var can_destroy_many = false
#var score: int = 0 : set = _set_score
var theme: TileProvider.TileTheme = TileProvider.TileTheme.SUMMER
var respawn_position = Vector2(50, 200)


# Called when the node enters the scene tree for the first time.
func _ready():
	pause_menu.connect("pressed_exit_button", exit_from_pause)
	recognizer.connect("symbol", process_symbol)
	recognizer.connect("click", process_click)
	character.connect("win", process_win)
	character.connect("lose", process_lose)
	character.connect("change_tile", process_change_tile)

	if SceneSwitcher.get_param('theme'):
		theme = SceneSwitcher.get_param('theme')
	
	start()
	

func start():
	difficulty = 0.15
	total_tiles_count = 0
	tiles_without_obstacles = 0
	obstacles_in_row = 0
	max_obstacles_in_row = 2
	last_tile_pos = 3
	last_tile_real_pos = Vector2(500, -1000)
	last_tile = null
	#score = 0
	$Camera2D.position = last_tile_real_pos
	$Camera2D.make_current()
	
	
	var pos = last_tile_real_pos
	var tile = base_tile.instantiate() as Tile
	tile.set_theme(theme)
	tile.position = pos
	tile.set_type(last_tile_orientation, 0)
	tile.last_in_row = true
	add_child(tile)
	RenderingServer.set_default_clear_color(tile.tile_provider.get_background_color())
	tile.out_of_screen.connect(remove_tile)
	character.position = tile.position + Vector2(0, -10)
	character.reset(false)
	last_tile = tile
	last_tile_orientation = Tile.ORIENTATION.LEFT_UP
	to_next_obstacle = 3
	generate_row()
	generate_row()
	generate_row()
	last_tile.show_treasure()
	character.set_tile(tile)
	audio_stream_player.play()
	can_remove_tiles = true
	await get_tree().create_timer(.5).timeout
	$Camera2D.position_smoothing_enabled = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	$Camera2D.position.y = min($Camera2D.position.y, character.position.y)
	pass

func generate_row():
	var max_length = last_tile_pos if last_tile_orientation == Tile.ORIENTATION.RIGHT_UP else world_tile_width - last_tile_pos - 1
	var length = max_length
	var offset: Vector2
	var _symbols: Array[Obstacle.SYMBOL]
	if last_tile_orientation == Tile.ORIENTATION.RIGHT_UP:
		last_tile_orientation = Tile.ORIENTATION.LEFT_UP
		offset = Tile.OFFSET_LEFT_UP
		last_tile_pos = last_tile_pos - length
		_symbols = [Obstacle.SYMBOL.V_LINE]
		to_next_obstacle = 4
	else:
		last_tile_orientation = Tile.ORIENTATION.RIGHT_UP
		offset = Tile.OFFSET_RIGHT_UP
		last_tile_pos = last_tile_pos + length
		_symbols = [Obstacle.SYMBOL.H_LINE, Obstacle.SYMBOL.V_LINE]
		to_next_obstacle = 2
	last_tile.orientation = last_tile_orientation
	if total_tiles_count < 3:
		to_next_obstacle = 100
	var tile: Tile
	for i in range(length):
		last_tile_real_pos = last_tile_real_pos + offset
		tile = base_tile.instantiate() as Tile
		tile.position = last_tile_real_pos
		tile.set_type(last_tile_orientation, (length - 1) - i)
		tile.set_theme(theme)
		add_child(tile)
		last_tile.next_tile = tile
		last_tile = tile
		total_tiles_count += 1
		to_next_obstacle -= 1
		if to_next_obstacle <= 0:
			tile.add_obstacle(_symbols)
			to_next_obstacle = 100


func process_symbol(_symbols: Array[Recognizer.SYMBOL]):
	character.duration = max(character.duration - 0.006, 0.325)
	var _tiles = get_tree().get_nodes_in_group('visible_tiles') as Array[Tile]
	_tiles.sort_custom(func(a, b): return a.position.y > b.position.y)
	var _affected = []
	var _active_symbol = null
	var _is_first_obstacle = true
	for _symbol in _symbols:
		for tile in _tiles:
			if tile.obstacle and tile.obstacle.apply_symbol_dry(_symbol):
				_active_symbol = _symbol
				break
		if _active_symbol:
			break
	if _active_symbol != null:
		for tile in _tiles:
			if tile.obstacle and not tile.bonus:
				if tile.obstacle.apply_symbol(_active_symbol):
					_affected.push_back(tile)
					if not tile.obstacle:
						character.restore_time()
						var tween = get_tree().create_tween()
						tween.tween_property($DrawerLayer/HintBackground, 'self_modulate', Color(1, 1, 1, 0.), 1.25)
						tween.parallel().tween_property($DrawerLayer/HintBackground/Sprite2D, 'scale', Vector2(25, 25), .75)
						tween.parallel().tween_property(%TextHint, 'self_modulate', Color(1, 1, 1, 0.), .25)
				if not can_destroy_many:
					break

func process_click():
	print(get_global_mouse_position())

func quit():
	await scene_transaction.fade_out()
	SceneSwitcher.change_scene_to_file('res://scenes/map/Map.tscn', {'respawn_position': respawn_position})
	#get_tree().quit()

func exit_from_pause():
	await scene_transaction.fade_out()
	SceneSwitcher.change_scene_to_file('res://scenes/main_menu/MainMenu.tscn')

func process_win():
	recognizer.TAKE_INPUT = false
	PlayerStats.pass_tutorial()
	$DrawerLayer/HintBackground/Sprite2D.position = character.get_screen_transform().origin
	$DrawerLayer/HintBackground/Sprite2D.scale = Vector2(0.25, 0.25)
	var tween = get_tree().create_tween()
	tween.tween_property($DrawerLayer/HintBackground, 'self_modulate', Color(1, 1, 1, 0.95), 1.5)
	tween.parallel().tween_property($DrawerLayer/HintBackground/Sprite2D, 'scale', Vector2(1, 1), .75)
	tween.tween_property(audio_stream_player, 'volume_db', -12, 1.0)
	await tween.finished
	quit()

func process_lose():
	recognizer.TAKE_INPUT = false
	character.duration = 0.5
	var tween = get_tree().create_tween()
	tween.tween_property($DrawerLayer/HintBackground, 'self_modulate', Color(1, 1, 1, 0.), 0.25)
	await get_tree().create_timer(1.5).timeout
	tween = get_tree().create_tween()
	tween.tween_property(audio_stream_player, 'volume_db', -12, 1.0)
	restart()

func process_change_tile(_tile: Tile):
	if _tile.next_tile:
		if _tile.next_tile.obstacle:
			character.slow_time()
			audio_stream_player.pitch_scale = 0.7
			$DrawerLayer/HintBackground/Sprite2D.position = _tile.next_tile.obstacle.get_screen_transform().origin + Vector2(0, 20)
			$DrawerLayer/HintBackground/Sprite2D.scale = Vector2(25, 25)
			var tween = get_tree().create_tween()
			tween.tween_property($DrawerLayer/HintBackground, 'self_modulate', Color(1, 1, 1, 0.7), 1.25)
			tween.parallel().tween_property($DrawerLayer/HintBackground/Sprite2D, 'scale', Vector2(1, 1), .75)
			tween.parallel().tween_property(%TextHint, 'self_modulate', Color(1, 1, 1, 1), 1.25)
		elif audio_stream_player.pitch_scale < 1 and not (_tile.next_tile.next_tile and _tile.next_tile.next_tile.obstacle):
			audio_stream_player.pitch_scale = 1

func remove_tile(_tile: Tile):
	if can_remove_tiles:
		_tile.remove_from_group('all_tiles')
		_tile.queue_free()

func restart():
	audio_stream_player.stop()
	can_remove_tiles = false
	character.can_run = false
	await scene_transaction.fade_out()
	var _tiles = get_tree().get_nodes_in_group('all_tiles') as Array[Tile]
	for _tile in _tiles:
		_tile.queue_free()
	get_tree().reload_current_scene()
