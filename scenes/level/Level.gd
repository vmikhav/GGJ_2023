extends Node2D

var last_tile_pos: int = 3
var last_tile_real_pos: Vector2 = Vector2(500, -3000)
var world_tile_width: int = 7
var last_tile_orientation: Tile.ORIENTATION = Tile.ORIENTATION.LEFT_UP 

@onready var base_tile = preload("res://sprites/tile/Tile.tscn") as PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	var pos = last_tile_real_pos
	var tile = base_tile.instantiate() as Tile
	tile.position = pos
	tile.set_type(last_tile_orientation, true)
	add_child(tile)
	$Camera2D.position = tile.position
	generate_row()
	generate_row()
	generate_row()
	generate_row()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
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
	for i in range(length):
		last_tile_real_pos = last_tile_real_pos + offset
		var tile = base_tile.instantiate() as Tile
		tile.position = last_tile_real_pos
		tile.set_type(last_tile_orientation, i == length - 1)
		add_child(tile)
