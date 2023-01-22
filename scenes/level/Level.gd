extends Node2D

@onready var base_tile = preload("res://sprites/tile/Tile.tscn") as PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	var tile = base_tile.instantiate() as Tile
	tile.position = Vector2(500, 300)
	add_child(tile)
	tile = base_tile.instantiate() as Tile
	tile.position = Vector2(340, 210)
	add_child(tile)
	tile = base_tile.instantiate() as Tile
	tile.position = Vector2(660, 390)
	add_child(tile)
	tile = base_tile.instantiate() as Tile
	tile.position = Vector2(340, 390)
	add_child(tile)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
