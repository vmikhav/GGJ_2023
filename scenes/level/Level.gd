extends Node2D

var last_tile_pos: int = 3
var last_tile_real_pos: Vector2 = Vector2(500, -1000)
var world_tile_width: int = 7
var last_tile_orientation: Tile.ORIENTATION = Tile.ORIENTATION.LEFT_UP 

@onready var pause_menu = %PauseMenu as PauseMenu
@onready var base_tile = preload("res://sprites/tile/Tile.tscn") as PackedScene
@onready var base_coin = preload("res://sprites/coin/Coin.tscn") as PackedScene
@onready var character = $Character as Node2D
@onready var recognizer = $Recognizer as Recognizer
@onready var scene_transaction = $DrawerLayer/SceneTransitionRect
var last_tile: Tile
var difficulty = 0.15
var total_tiles_count = 0
var tiles_without_obstacles = 0
var obstacles_in_row = 0
var max_obstacles_in_row = 2
var to_next_obstacle = 0
var can_remove_tiles = true
var can_destroy_many = false
var score: int = 0 : set = _set_score
var theme: TileProvider.TileTheme = TileProvider.TileTheme.AUTUMN
var respawn_position = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pause_menu.connect("pressed_exit_button", exit_from_pause)
	recognizer.connect("symbol", process_symbol)
	recognizer.connect("click", process_click)
	character.connect("win", process_win)
	character.connect("lose", process_lose)
	$DrawerLayer/WonContainer/MarginContainer/VBoxContainer/Restart.pressed.connect(restart)
	$DrawerLayer/LoseContainer/MarginContainer/VBoxContainer/Restart.pressed.connect(restart)
	$DrawerLayer/WonContainer/MarginContainer/VBoxContainer/Quit.pressed.connect(quit)
	$DrawerLayer/LoseContainer/MarginContainer/VBoxContainer/Quit.pressed.connect(quit)
	if SceneSwitcher.get_param('theme'):
		theme = SceneSwitcher.get_param('theme')
	if SceneSwitcher.get_param('respawn_position'):
		respawn_position = SceneSwitcher.get_param('respawn_position')
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
	score = 0
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
	character.reset()
	last_tile = tile
	last_tile_orientation = Tile.ORIENTATION.LEFT_UP if randi_range(0, 1) else Tile.ORIENTATION.RIGHT_UP
	to_next_obstacle = randi_range(5, 7)
	generate_row()
	while total_tiles_count < 150:
		generate_row()
	last_tile.show_treasure()
	character.set_tile(tile)
	await scene_transaction.fade_in()
	$AudioStreamPlayer.play()
	can_remove_tiles = true
	await get_tree().create_timer(.5).timeout
	$Camera2D.position_smoothing_enabled = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Camera2D.position.y = min($Camera2D.position.y, character.position.y)


func generate_row():
	var max_length = last_tile_pos if last_tile_orientation == Tile.ORIENTATION.RIGHT_UP else world_tile_width - last_tile_pos - 1
	var length = randi_range(3, max_length)
	var offset: Vector2
	if last_tile_orientation == Tile.ORIENTATION.RIGHT_UP:
		last_tile_orientation = Tile.ORIENTATION.LEFT_UP
		offset = Tile.OFFSET_LEFT_UP
		last_tile_pos = last_tile_pos - length
	else:
		last_tile_orientation = Tile.ORIENTATION.RIGHT_UP
		offset = Tile.OFFSET_RIGHT_UP
		last_tile_pos = last_tile_pos + length
	last_tile.orientation = last_tile_orientation
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
			var _raw_weight = randi_range(1, 9)
			var _weight = floori(sqrt(_raw_weight))
			tile.generate_obstacle(_weight)
			difficulty = min(difficulty + 0.00125, 0.7)
			obstacles_in_row = max(0, obstacles_in_row - 1)
			to_next_obstacle = randi_range(floori(_weight * randf_range(1, 2) + obstacles_in_row/2), ceil(_raw_weight/(1+difficulty*2)) + 1 + (3 if randf() > difficulty else 0))
			obstacles_in_row += (obstacles_in_row + 2) if to_next_obstacle == 1 else 0
		#if total_tiles_count > 5:
		#	tiles_without_obstacles += 1
		#	if obstacles_in_row < max_obstacles_in_row and (tiles_without_obstacles > 5 or randf() < difficulty):
		#		var _raw_weight = randi_range(1, 9)
		#		var _weight = floori(sqrt(randi_range(1, 9)))
		#		tile.generate_obstacle(_weight)
		#		tiles_without_obstacles = 0
		#		obstacles_in_row += _weight
		#		difficulty = min(difficulty + 0.0075, 0.7)
		#	else:
		#		obstacles_in_row = max(0, obstacles_in_row - 1)
	if randi_range(1, 4) == 1:
		tile = base_tile.instantiate() as Tile
		tile.position = last_tile_real_pos + Vector2(0, 180)
		tile.set_type(last_tile_orientation, 1)
		tile.last_in_row = true
		tile.set_theme(theme)
		add_child(tile)
		tile.generate_obstacle(1)
		tile.bonus = true

func process_symbol(_symbols: Array[Recognizer.SYMBOL]):
	character.duration = max(character.duration - 0.006, 0.325)
	var _tiles = get_tree().get_nodes_in_group('visible_tiles') as Array[Tile]
	_tiles.sort_custom(func(a, b): return a.position.y > b.position.y)
	var _affected = []
	var _active_symbol = null
	var _is_first_obstacle = true
	for _symbol in _symbols:
		_is_first_obstacle = true
		for tile in _tiles:
			if tile.obstacle and not tile.bonus:
				if tile.obstacle.apply_symbol_dry(_symbol):
					_active_symbol = _symbol
					break
				_is_first_obstacle = false
		if _active_symbol:
			break
	if not _active_symbol:
		for _symbol in _symbols:
			for tile in _tiles:
				if tile.obstacle and tile.bonus:
					if tile.obstacle.apply_symbol_dry(_symbol):
						_active_symbol = _symbol
						break
			if _active_symbol:
				break
	if _active_symbol != null:
		for tile in _tiles:
			if tile.obstacle and not tile.bonus:
				if tile.obstacle.apply_symbol(_active_symbol):
					_affected.push_back(tile)
				if not can_destroy_many:
					break
		if not _affected.size():
			for tile in _tiles:
				if tile.obstacle and tile.bonus:
					if tile.obstacle.apply_symbol(_active_symbol):
						_affected.push_back(tile)
	
	if _affected.size():
		var _delta = 0
		for i in range(_affected.size()):
			_delta += i + 1
			var income = 10 if _affected[i].bonus else i+1
			for j in range(income):
				var coin = base_coin.instantiate() as Node2D
				coin.position = _affected[i].get_global_transform_with_canvas().origin + Vector2(randi_range(-25, 25), randi_range(-25, 25))
				coin.scale = Vector2(0.5, 0.5)
				coin.z_index = 1
				$DrawerLayer.add_child(coin)
				var tween = create_tween()
				var time = randf_range(0.25, 0.75)
				tween.tween_property(coin, 'position', Vector2(60, 60), time)
				tween.parallel().tween_property(coin, 'scale', Vector2(1, 1), time)
				tween.finished.connect(func ():
					coin.queue_free()
					score += 1
				)

func process_click():
	print(get_global_mouse_position())

func respawn():
	$AudioStreamPlayer.play()
	can_remove_tiles = true
	await scene_transaction.fade_in()
	recognizer.TAKE_INPUT = true
	$DrawerLayer/WonContainer.visible = false
	$DrawerLayer/LoseContainer.visible = false
	character.reset()
	character.set_tile(character.last_save_tile)
	$Camera2D.position.y = min($Camera2D.position.y, character.position.y)
	
func restart():
	$AudioStreamPlayer.stop()
	can_remove_tiles = false
	character.can_run = false
	await scene_transaction.fade_out()
	var _tiles = get_tree().get_nodes_in_group('all_tiles') as Array[Tile]
	for _tile in _tiles:
		_tile.queue_free()
	get_tree().reload_current_scene()
	#recognizer.TAKE_INPUT = true
	#$DrawerLayer/WonContainer.visible = false
	#$DrawerLayer/LoseContainer.visible = false
	#$DrawerLayer/ScoreContainer.visible = true
	#start()
	
func exit_from_pause():
	SceneSwitcher.change_scene_to_file('res://scenes/map/Map.tscn', {'respawn_position': respawn_position})
	
func quit():
	SceneSwitcher.change_scene_to_file('res://scenes/map/Map.tscn', {'respawn_position': respawn_position})
	#get_tree().quit()

func process_win():
	recognizer.TAKE_INPUT = false
	$DrawerLayer/WonContainer.visible = true
	PlayerStats.add_coins(score)

func process_lose():
	recognizer.TAKE_INPUT = false
	$DrawerLayer/LoseContainer.visible = true
	PlayerStats.add_coins(score * 0.10)

func remove_tile(_tile: Tile):
	if can_remove_tiles:
		_tile.remove_from_group('all_tiles')
		_tile.queue_free()

func _set_score(value):
	score = value
	if value == 0:
		return
	var label = $DrawerLayer/ScoreContainer/MarginContainer/Label as Label
	var coin = $DrawerLayer/ScoreContainer/MarginContainer/Coin as Node2D
	label.pivot_offset.x = label.size.x
	label.pivot_offset.y = label.size.y / 2
	label.text = String.num(score)
	var tween = create_tween()
	tween.tween_property(label, 'scale', Vector2(1.1, 1.1), 0.15)
	tween.parallel().tween_property(coin, 'scale', Vector2(2, 2), 0.15)
	tween.tween_property(label, 'scale', Vector2(1.0, 1.0), 0.35)
	tween.parallel().tween_property(coin, 'scale', Vector2(1.75, 1.75), 0.35)
