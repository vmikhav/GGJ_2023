extends Node2D

var last_tile_pos: int = 3
var last_tile_real_pos: Vector2 = Vector2(500, -1000)
var world_tile_width: int = 7
var last_tile_orientation: Tile.ORIENTATION = Tile.ORIENTATION.LEFT_UP 

@onready var base_tile = preload("res://sprites/tile/Tile.tscn") as PackedScene
#@onready var character = $Character as Node2D
@onready var recognizer = $Recognizer as Recognizer
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
var theme: TileProvider.TileTheme = TileProvider.TileTheme.AUTUMN
var respawn_position = null


# Called when the node enters the scene tree for the first time.
func _ready():
	PlayerStats.is_tutor = true
	recognizer.connect("symbol", process_symbol)
	recognizer.connect("click", process_click)
	

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
	#character.position = tile.position + Vector2(0, -10)
	#character.reset(false)
	last_tile = tile
	last_tile_orientation = Tile.ORIENTATION.LEFT_UP if randi_range(0, 1) else Tile.ORIENTATION.RIGHT_UP
	to_next_obstacle = 2 #randi_range(5, 7)
	generate_row()
	while total_tiles_count < 3:
		generate_row()
	last_tile.show_treasure()
	#character.set_tile(tile)
	audio_stream_player.play()
	can_remove_tiles = true
	await get_tree().create_timer(.5).timeout
	$Camera2D.position_smoothing_enabled = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	#$Camera2D.position.y = min($Camera2D.position.y, character.position.y)
	pass

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
	#character.duration = max(character.duration - 0.006, 0.325)
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
	

func process_click():
	print(get_global_mouse_position())

func quit():
	SceneSwitcher.change_scene_to_file('res://scenes/map/Map.tscn', {'respawn_position': respawn_position})
	#get_tree().quit()

func remove_tile(_tile: Tile):
	if can_remove_tiles:
		_tile.remove_from_group('all_tiles')
		_tile.queue_free()

