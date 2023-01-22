class_name Tile
extends Node2D

@onready var tile_provider: TileProvider = $TileProvider as TileProvider

# Called when the node enters the scene tree for the first time.
func _ready():
	tile_provider.tile_theme = TileProvider.TileTheme.SUMMER
	set_tile()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func set_tile():
	var tile_info = tile_provider.get_tile()
	$Sprite2D.texture = load(tile_info.path);
	if tile_info.bridge:
		$Sprite2D.set_position(Vector2(1, 10))
	else:
		$Sprite2D.set_position(Vector2(3, 20) if tile_info.thin else Vector2(3, 40))
