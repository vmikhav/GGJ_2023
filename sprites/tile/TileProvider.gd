class_name TileProvider
extends Node

enum TileTheme {
	SUMMER
}

const path_summer: String = 'res://sprites/tile/assets/summer/'

var config_summer: Array[TileInfo] = [
	TileInfo.new(path_summer + 'Recurso 24.png', true, true, false, false),
	TileInfo.new(path_summer + 'Recurso 25.png', true, true, false, false),
	TileInfo.new(path_summer + 'Recurso 29.png', true, false, true, true),
	TileInfo.new(path_summer + 'Recurso 28.png', true, false, true, true),
	TileInfo.new(path_summer + 'Recurso 27.png', false, false, true, true),
	TileInfo.new(path_summer + 'Recurso 26.png', false, false, true, true),
	TileInfo.new(path_summer + 'Recurso 33.png', true, false, true, true),
	TileInfo.new(path_summer + 'Recurso 32.png', true, false, true, true),
	TileInfo.new(path_summer + 'Recurso 31.png', false, false, true, true),
	TileInfo.new(path_summer + 'Recurso 30.png', false, false, true, true),
	TileInfo.new(path_summer + 'Recurso 37.png', true, false, true, true),
	TileInfo.new(path_summer + 'Recurso 36.png', true, false, true, true),
	TileInfo.new(path_summer + 'Recurso 35.png', false, false, true, true),
	TileInfo.new(path_summer + 'Recurso 34.png', false, false, true, true),
]

var config: Dictionary = {
	TileTheme.SUMMER: config_summer
}

@export var tile_theme: TileTheme = TileTheme.SUMMER

func get_tile(with_bridges: bool = true) -> TileInfo:
	var tile: TileInfo = config[tile_theme].pick_random()
	while (not with_bridges) and tile.bridge:
		tile = config[tile_theme].pick_random()
	return tile
