extends Node2D

var last_tile_pos: int = 3
var last_tile_real_pos: Vector2 = Vector2(500, -1000)
var world_tile_width: int = 7
var last_tile_orientation: Tile.ORIENTATION = Tile.ORIENTATION.LEFT_UP 

@onready var base_tile = preload("res://sprites/tile/Tile.tscn") as PackedScene
@onready var character = $Character as Node2D
@onready var recognizer = $Recognizer as Recognizer
@onready var scene_transaction = $DrawerLayer/SceneTransitionRect
var last_tile: Tile
var difficulty = 0.25
var total_tiles_count = 0
var tiles_without_obstacles = 0
var obstacles_in_row = 0
var max_obstacles_in_row = 2
var can_remove_tiles = true

# Called when the node enters the scene tree for the first time.
func _ready():
	RenderingServer.set_default_clear_color(Color8(169, 242, 254))#Color('EDE5CD')
	recognizer.connect("symbol", process_symbol)
	recognizer.connect("click", process_click)
	character.connect("win", process_win)
	character.connect("lose", process_lose)
	$DrawerLayer/WonContainer/MarginContainer/VBoxContainer/Restart.pressed.connect(restart)
	$DrawerLayer/LoseContainer/MarginContainer/VBoxContainer/Restart.pressed.connect(restart)
	$DrawerLayer/WonContainer/MarginContainer/VBoxContainer/Quit.pressed.connect(quit)
	$DrawerLayer/LoseContainer/MarginContainer/VBoxContainer/Quit.pressed.connect(quit)
	start()
	

func start():
	difficulty = 0.25
	total_tiles_count = 0
	tiles_without_obstacles = 0
	obstacles_in_row = 0
	max_obstacles_in_row = 2
	last_tile_pos = 3
	last_tile_real_pos = Vector2(500, -1000)
	last_tile = null
	$Camera2D.position = last_tile_real_pos
	$Camera2D.make_current()
	
	var pos = last_tile_real_pos
	var tile = base_tile.instantiate() as Tile
	tile.position = pos
	tile.set_type(last_tile_orientation, true)
	add_child(tile)
	tile.out_of_screen.connect(remove_tile)
	character.position = tile.position + Vector2(0, -10)
	character.reset()
	last_tile = tile
	last_tile_orientation = Tile.ORIENTATION.LEFT_UP if randi_range(0, 1) else Tile.ORIENTATION.RIGHT_UP
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
		tile.set_type(last_tile_orientation, i == length - 1)
		add_child(tile)
		last_tile.next_tile = tile
		last_tile = tile
		total_tiles_count += 1
		if total_tiles_count > 5:
			tiles_without_obstacles += 1
			if obstacles_in_row < max_obstacles_in_row and (tiles_without_obstacles > 4 or randf() < difficulty):
				tile.add_obstacle()
				tiles_without_obstacles = 0
				obstacles_in_row += 1
				difficulty = min(difficulty + 0.0175, 0.7)
			else:
				obstacles_in_row = 0

func process_symbol(_symbols: Array[Recognizer.SYMBOL]):
	character.duration = max(character.duration - 0.01, 0.325)
	var _tiles = get_tree().get_nodes_in_group('visible_tiles') as Array[Tile]
	_tiles.sort_custom(func(a, b): return a.position.y > b.position.y)
	var _affected = 0
	for tile in _tiles:
		if tile.obstacle:
			for _symbol in _symbols:
				if tile.obstacle.apply_symbol(_symbol):
					_affected += 1
					break
			break

func process_click():
	print(get_global_mouse_position())

func restart():
	$AudioStreamPlayer.stop()
	can_remove_tiles = false
	character.can_run = false
	await scene_transaction.fade_out()
	var _tiles = get_tree().get_nodes_in_group('all_tiles') as Array[Tile]
	for _tile in _tiles:
		_tile.queue_free()
	recognizer.TAKE_INPUT = true
	$DrawerLayer/WonContainer.visible = false
	$DrawerLayer/LoseContainer.visible = false
	start()

func quit():
	get_tree().quit()

func process_win():
	recognizer.TAKE_INPUT = false
	$DrawerLayer/WonContainer.visible = true

func process_lose():
	recognizer.TAKE_INPUT = false
	$DrawerLayer/LoseContainer.visible = true

func remove_tile(_tile: Tile):
	if can_remove_tiles:
		_tile.remove_from_group('all_tiles')
		_tile.queue_free()
