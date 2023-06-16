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
var second_last_in_row: bool
var next_tile: Tile
var obstacle: Obstacle = null
var can_decorate_center: bool = true
var can_decorate_edge: bool = true
var theme: TileProvider.TileTheme

signal out_of_screen(tile: Tile)

# Called when the node enters the scene tree for the first time.
func _ready():
	tile_provider.tile_theme = theme
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
	theme = _theme

func set_type(_orientation: ORIENTATION, _tiles_to_end: int):
	orientation = _orientation
	last_in_row = _tiles_to_end == 0
	second_last_in_row = _tiles_to_end == 1

func set_tile():
	var tile_info = tile_provider.get_tile(not last_in_row)
	sprite.texture = load(tile_info.path);
	can_decorate_center = tile_info.decorate_center
	can_decorate_edge = tile_info.decorate_edge
	if tile_info.bridge:
		sprite.set_position(Vector2(0, 13))
		if orientation == Tile.ORIENTATION.RIGHT_UP:
			sprite.flip_h = true
	else:
		var _decorate_left = (not last_in_row) if orientation == Tile.ORIENTATION.RIGHT_UP else last_in_row
		var _multiplier = -1 if _decorate_left else 1
		var _y_offset = 25 if tile_info.thin else 40
		var _x_offset = (2 if tile_info.thin else 3) * _multiplier
		$Sprite2D.set_position(Vector2(_x_offset, _y_offset))
		var _egde_slots = [
			Vector2i(90 * _multiplier, -12),
			Vector2i(28 * _multiplier, -58)
			#Vector2i(95 * _multiplier, -10),
			#Vector2i(40 * _multiplier, -40),
			#Vector2i(26 * _multiplier, -62)
		]
		var decors = tile_provider.get_decorations()
		var sprites = []
		for _decor in decors:
			if not can_decorate_edge and _decor.size != TileDecorationsInfo.Size.SMALL:
				continue
			if _decor.size == TileDecorationsInfo.Size.LARGE and second_last_in_row:
				continue
			var _decor_sprite = Sprite2D.new()
			_decor_sprite.texture = load(_decor.path)
			_decor_sprite.centered = false
			if _decor.oriented:
				_decor_sprite.flip_h = _decorate_left
			var _offset = Vector2i(0, 0)
			if not can_decorate_center or _decor.size != TileDecorationsInfo.Size.SMALL:
				var _i = randi_range(0, _egde_slots.size() - 1)
				_offset = _egde_slots[_i]
				_egde_slots.remove_at(_i)
			else:
				_offset = Vector2i(randi_range(-10, 10), randi_range(-10, 10))
			var _center = Vector2i(-floori((_decor_sprite.texture.get_width() * (1 if _offset.x < 0 else 2)) / 3), -_decor_sprite.texture.get_height())
			_decor_sprite.position = _center + _offset
			sprites.push_back({'sprite': _decor_sprite, 'y': _offset.y})
		sprites.sort_custom(func(a, b): return a.y < b.y)
		for item in sprites:
			$Sprite2D/Decorations.add_child(item.sprite)

func generate_obstacle(number: int = 1):
	var symbols: Array[Obstacle.SYMBOL] = []
	var new_symbol: Obstacle.SYMBOL = Obstacle.SYMBOL[Obstacle.SYMBOL.keys().pick_random()]
	var last_symbol: Obstacle.SYMBOL = new_symbol
	symbols.push_back(new_symbol)
	while symbols.size() < number:
		new_symbol = Obstacle.SYMBOL[Obstacle.SYMBOL.keys().pick_random()]
		if last_symbol != new_symbol:
			last_symbol = new_symbol
			symbols.push_back(new_symbol)
	add_obstacle(symbols)

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
