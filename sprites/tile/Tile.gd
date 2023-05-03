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
var next_tile: Tile
var obstacle: Obstacle = null
var can_decorate_center: bool = true

signal out_of_screen(tile: Tile)

# Called when the node enters the scene tree for the first time.
func _ready():
	set_theme(TileProvider.TileTheme.SUMMER)
	set_tile()
	add_to_group('all_tiles', true)
	$VisibleOnScreenNotifier2D.screen_entered.connect(func():
		add_to_group('visible_tiles', true)
	)
	$VisibleOnScreenNotifier2D.screen_exited.connect(func():
		remove_from_group('visible_tiles')
		out_of_screen.emit(self)
	)

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
	can_decorate_center = tile_info.decorate_center
	if tile_info.bridge:
		sprite.set_position(Vector2(0, 13))
		if orientation == Tile.ORIENTATION.RIGHT_UP:
			sprite.flip_h = true
	else:
		$Sprite2D.set_position(Vector2(3, 20) if tile_info.thin else Vector2(3, 40))

func add_obstacle(symbols: Array[Obstacle.SYMBOL] = []):
	if not symbols.size():
		symbols.push_back(Obstacle.SYMBOL[Obstacle.SYMBOL.keys().pick_random()])
		symbols.push_back(Obstacle.SYMBOL[Obstacle.SYMBOL.keys().pick_random()])
	
	obstacle = $Sprite2D/Rune as Obstacle
	obstacle.tile = self
	obstacle.visible = true
	
	obstacle.set_symbols(symbols)

func show_treasure():
	$Sprite2D/Chest.visible = true
	var need_flip = orientation == Tile.ORIENTATION.LEFT_UP
	if (need_flip != $Sprite2D/Chest.flip_h):
		$Sprite2D/Chest.position.x = -$Sprite2D/Chest.position.x
	$Sprite2D/Chest.flip_h = need_flip
	if obstacle:
		obstacle.visible = false
		obstacle = null
