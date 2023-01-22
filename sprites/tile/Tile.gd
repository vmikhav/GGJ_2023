class_name Tile
extends Node2D

enum ORIENTATION {
	RIGHT_UP,
	LEFT_UP,
	RIGHT_DOWN,
	LEFT_DOWN,
}

const OFFSET_LEFT_UP: Vector2 = Vector2(-160, -90)
const OFFSET_RIGHT_UP: Vector2 = Vector2(160, -90)
const OFFSET_LEFT_DOWN: Vector2 = Vector2(-160, 90)
const OFFSET_RIGHT_DOWN: Vector2 = Vector2(160, 90)

@onready var tile_provider: TileProvider = $TileProvider as TileProvider
@onready var sprite: Sprite2D = $Sprite2D as Sprite2D

var orientation: ORIENTATION
var last_in_row: bool

# Called when the node enters the scene tree for the first time.
func _ready():
	set_theme(TileProvider.TileTheme.SUMMER)
	set_tile()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_theme(_theme: TileProvider.TileTheme):
	tile_provider.tile_theme = _theme

func set_type(_orientation: ORIENTATION, _last: bool):
	orientation = _orientation
	last_in_row = _last

func set_tile():
	var tile_info = tile_provider.get_tile(not last_in_row)
	sprite.texture = load(tile_info.path);
	if tile_info.bridge:
		sprite.set_position(Vector2(1, 10))
	else:
		$Sprite2D.set_position(Vector2(3, 20) if tile_info.thin else Vector2(3, 40))
