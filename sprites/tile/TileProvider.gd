class_name TileProvider
extends Node

enum TileTheme {
	SUMMER, NIGHT_FOREST, BEACH, FARM, AUTUMN,
}

const path_summer: String = 'res://sprites/tile/assets/summer/'
const path_night_forest: String = 'res://sprites/tile/assets/night forest/'
const path_beach: String = 'res://sprites/tile/assets/beach/'
const path_farm: String = 'res://sprites/tile/assets/farm/'
const path_authum: String = 'res://sprites/tile/assets/autumn/'

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
	TileInfo.new(path_summer + 'Recurso 41.png', true, false, true, true),
	TileInfo.new(path_summer + 'Recurso 40.png', true, false, true, true),
	TileInfo.new(path_summer + 'Recurso 39.png', false, false, true, true),
	TileInfo.new(path_summer + 'Recurso 38.png', false, false, true, true),
	TileInfo.new(path_summer + 'Recurso 43.png', true, false, false, false),
	TileInfo.new(path_summer + 'Recurso 42.png', false, false, false, false),
	TileInfo.new(path_summer + 'Recurso 45.png', true, false, false, false),
	TileInfo.new(path_summer + 'Recurso 44.png', false, false, false, false),
	TileInfo.new(path_summer + 'Recurso 46.png', true, false, true, false),
	TileInfo.new(path_summer + 'Recurso 47.png', true, false, true, false),
	TileInfo.new(path_summer + 'Recurso 48.png', true, false, true, false),
	TileInfo.new(path_summer + 'Recurso 49.png', true, false, false, false),
	TileInfo.new(path_summer + 'Recurso 50.png', true, false, false, false),
]

var config_summer_decor: Array[TileDecorationsInfo] = [
	TileDecorationsInfo.new(path_summer + 'Recurso 5.png', TileDecorationsInfo.Size.SMALL, false),
	TileDecorationsInfo.new(path_summer + 'Recurso 6.png', TileDecorationsInfo.Size.SMALL, false),
	TileDecorationsInfo.new(path_summer + 'Recurso 7.png', TileDecorationsInfo.Size.SMALL, false),
	TileDecorationsInfo.new(path_summer + 'Recurso 8.png', TileDecorationsInfo.Size.THIN, false),
	TileDecorationsInfo.new(path_summer + 'Recurso 9.png', TileDecorationsInfo.Size.SMALL, false),
	TileDecorationsInfo.new(path_summer + 'Recurso 10.png', TileDecorationsInfo.Size.THIN, false),
	TileDecorationsInfo.new(path_summer + 'Recurso 11.png', TileDecorationsInfo.Size.SMALL, false),
	TileDecorationsInfo.new(path_summer + 'Recurso 17.png', TileDecorationsInfo.Size.THIN, true),
	TileDecorationsInfo.new(path_summer + 'Recurso 18.png', TileDecorationsInfo.Size.THIN, true),
	TileDecorationsInfo.new(path_summer + 'Recurso 19.png', TileDecorationsInfo.Size.LARGE, false),
	TileDecorationsInfo.new(path_summer + 'Recurso 20.png', TileDecorationsInfo.Size.LARGE, false),
	TileDecorationsInfo.new(path_summer + 'Recurso 21.png', TileDecorationsInfo.Size.LARGE, false),
]

var config_night_forest: Array[TileInfo] = [
	TileInfo.new(path_night_forest + 'Recurso 25.png', false, false, true, true),
	TileInfo.new(path_night_forest + 'Recurso 26.png', false, false, true, true),
	TileInfo.new(path_night_forest + 'Recurso 27.png', true, false, true, true),
	TileInfo.new(path_night_forest + 'Recurso 28.png', true, false, true, true),
	TileInfo.new(path_night_forest + 'Recurso 29.png', false, false, true, true),
	TileInfo.new(path_night_forest + 'Recurso 30.png', false, true, false, false),
	TileInfo.new(path_night_forest + 'Recurso 31.png', false, true, false, false),
	TileInfo.new(path_night_forest + 'Recurso 32.png', true, false, true, true),
	TileInfo.new(path_night_forest + 'Recurso 33.png', false, false, false, false),
	TileInfo.new(path_night_forest + 'Recurso 34.png', true, false, false, false),
	TileInfo.new(path_night_forest + 'Recurso 35.png', false, false, false, false),
	TileInfo.new(path_night_forest + 'Recurso 36.png', true, false, false, false),
	TileInfo.new(path_night_forest + 'Recurso 37.png', true, false, true, false),
	TileInfo.new(path_night_forest + 'Recurso 38.png', true, false, false, false),
	TileInfo.new(path_night_forest + 'Recurso 39.png', true, false, false, false),
]

var config_night_forest_decor: Array[TileDecorationsInfo] = [
	TileDecorationsInfo.new(path_night_forest + 'Recurso 6.png', TileDecorationsInfo.Size.SMALL, false),
	TileDecorationsInfo.new(path_night_forest + 'Recurso 7.png', TileDecorationsInfo.Size.SMALL, false),
	TileDecorationsInfo.new(path_night_forest + 'Recurso 8.png', TileDecorationsInfo.Size.SMALL, false),
	TileDecorationsInfo.new(path_night_forest + 'Recurso 9.png', TileDecorationsInfo.Size.THIN, false),
	TileDecorationsInfo.new(path_night_forest + 'Recurso 10.png', TileDecorationsInfo.Size.SMALL, false),
	TileDecorationsInfo.new(path_night_forest + 'Recurso 11.png', TileDecorationsInfo.Size.SMALL, false),
	TileDecorationsInfo.new(path_night_forest + 'Recurso 12.png', TileDecorationsInfo.Size.SMALL, false),
	TileDecorationsInfo.new(path_night_forest + 'Recurso 17.png', TileDecorationsInfo.Size.THIN, true),
	TileDecorationsInfo.new(path_night_forest + 'Recurso 18.png', TileDecorationsInfo.Size.THIN, true),
	TileDecorationsInfo.new(path_night_forest + 'Recurso 20.png', TileDecorationsInfo.Size.LARGE, false),
	TileDecorationsInfo.new(path_night_forest + 'Recurso 21.png', TileDecorationsInfo.Size.LARGE, false),
	TileDecorationsInfo.new(path_night_forest + 'Recurso 22.png', TileDecorationsInfo.Size.LARGE, false),
]

var config_beach: Array[TileInfo] = [
	TileInfo.new(path_beach + 'Recurso 21.png', false, false, true, true),
	TileInfo.new(path_beach + 'Recurso 22.png', false, false, true, true),
	TileInfo.new(path_beach + 'Recurso 23.png', true, false, true, true),
	TileInfo.new(path_beach + 'Recurso 24.png', true, false, true, true),
	TileInfo.new(path_beach + 'Recurso 25.png', true, false, true, true),
	TileInfo.new(path_beach + 'Recurso 26.png', true, false, true, false),
	TileInfo.new(path_beach + 'Recurso 27.png', false, false, true, true),
	TileInfo.new(path_beach + 'Recurso 28.png', false, false, true, true),
	TileInfo.new(path_beach + 'Recurso 29.png', true, false, true, true),
	TileInfo.new(path_beach + 'Recurso 30.png', true, false, true, true),
	TileInfo.new(path_beach + 'Recurso 31.png', true, false, true, false),
	TileInfo.new(path_beach + 'Recurso 32.png', false, true, false, false),
	TileInfo.new(path_beach + 'Recurso 33.png', false, true, false, false),
]

var config_beach_decor: Array[TileDecorationsInfo] = [
	TileDecorationsInfo.new(path_beach + 'Recurso 7.png', TileDecorationsInfo.Size.THIN, true),
	TileDecorationsInfo.new(path_beach + 'Recurso 8.png', TileDecorationsInfo.Size.SMALL, false),
	TileDecorationsInfo.new(path_beach + 'Recurso 9.png', TileDecorationsInfo.Size.SMALL, false),
	TileDecorationsInfo.new(path_beach + 'Recurso 10.png', TileDecorationsInfo.Size.SMALL, false),
	TileDecorationsInfo.new(path_beach + 'Recurso 11.png', TileDecorationsInfo.Size.SMALL, false),
	TileDecorationsInfo.new(path_beach + 'Recurso 16.png', TileDecorationsInfo.Size.LARGE, true),
]

var config_farm: Array[TileInfo] = [
	TileInfo.new(path_farm + 'Recurso 1.png', false, false, true, true),
	TileInfo.new(path_farm + 'Recurso 2.png', false, false, true, true),
	TileInfo.new(path_farm + 'Recurso 3.png', false, false, true, true),
	TileInfo.new(path_farm + 'Recurso 4.png', false, false, true, true),
	TileInfo.new(path_farm + 'Recurso 5.png', true, false, true, true),
	TileInfo.new(path_farm + 'Recurso 6.png', true, false, true, true),
	TileInfo.new(path_farm + 'Recurso 7.png', true, false, true, true),
	TileInfo.new(path_farm + 'Recurso 8.png', true, false, true, false),
	TileInfo.new(path_farm + 'Recurso 9.png', true, false, true, true),
	TileInfo.new(path_farm + 'Recurso 10.png', false, true, false, false),
	TileInfo.new(path_farm + 'Recurso 11.png', false, true, false, false),
]

var config_farm_decor: Array[TileDecorationsInfo] = [
	TileDecorationsInfo.new(path_farm + 'Recurso 18.png', TileDecorationsInfo.Size.LARGE, false),
	TileDecorationsInfo.new(path_farm + 'Recurso 20.png', TileDecorationsInfo.Size.SMALL, false),
	TileDecorationsInfo.new(path_farm + 'Recurso 21.png', TileDecorationsInfo.Size.SMALL, false),
	TileDecorationsInfo.new(path_farm + 'Recurso 22.png', TileDecorationsInfo.Size.SMALL, false),
	TileDecorationsInfo.new(path_farm + 'Recurso 23.png', TileDecorationsInfo.Size.SMALL, false),
	TileDecorationsInfo.new(path_farm + 'Recurso 24.png', TileDecorationsInfo.Size.THIN, false),
	TileDecorationsInfo.new(path_farm + 'Recurso 25.png', TileDecorationsInfo.Size.SMALL, false),
	TileDecorationsInfo.new(path_farm + 'Recurso 26.png', TileDecorationsInfo.Size.SMALL, false),
	TileDecorationsInfo.new(path_farm + 'Recurso 27.png', TileDecorationsInfo.Size.SMALL, false),
	TileDecorationsInfo.new(path_farm + 'Recurso 28.png', TileDecorationsInfo.Size.THIN, true),
	TileDecorationsInfo.new(path_farm + 'Recurso 29.png', TileDecorationsInfo.Size.THIN, true),
]

var config_autumn: Array[TileInfo] = [
	TileInfo.new(path_authum + 'Recurso 24.png', false, false, true, true),
	TileInfo.new(path_authum + 'Recurso 25.png', false, false, true, true),
	TileInfo.new(path_authum + 'Recurso 26.png', false, false, true, true),
	TileInfo.new(path_authum + 'Recurso 27.png', true, false, true, true),
	TileInfo.new(path_authum + 'Recurso 28.png', true, false, true, true),
	TileInfo.new(path_authum + 'Recurso 29.png', true, false, true, true),
	TileInfo.new(path_authum + 'Recurso 30.png', true, false, true, false),
	TileInfo.new(path_authum + 'Recurso 31.png', true, false, true, false),
	TileInfo.new(path_authum + 'Recurso 32.png', false, true, false, false),
	TileInfo.new(path_authum + 'Recurso 33.png', false, true, false, false),
]

var config_autumn_decor: Array[TileDecorationsInfo] = [
	TileDecorationsInfo.new(path_authum + 'Recurso 6.png', TileDecorationsInfo.Size.SMALL, false),
	TileDecorationsInfo.new(path_authum + 'Recurso 7.png', TileDecorationsInfo.Size.THIN, true),
	TileDecorationsInfo.new(path_authum + 'Recurso 8.png', TileDecorationsInfo.Size.SMALL, false),
	TileDecorationsInfo.new(path_authum + 'Recurso 9.png', TileDecorationsInfo.Size.SMALL, false),
	TileDecorationsInfo.new(path_authum + 'Recurso 10.png', TileDecorationsInfo.Size.SMALL, false),
	TileDecorationsInfo.new(path_authum + 'Recurso 17.png', TileDecorationsInfo.Size.LARGE, false),
	TileDecorationsInfo.new(path_authum + 'Recurso 18.png', TileDecorationsInfo.Size.LARGE, false),
	TileDecorationsInfo.new(path_authum + 'Recurso 19.png', TileDecorationsInfo.Size.LARGE, false),
]

var config: Dictionary = {
	TileTheme.SUMMER: {'tiles': config_summer, 'decor': config_summer_decor, 'background': Color8(169, 242, 254)},
	TileTheme.NIGHT_FOREST: {'tiles': config_night_forest, 'decor': config_night_forest_decor, 'background': Color8(12, 41, 55)},
	TileTheme.BEACH: {'tiles': config_beach, 'decor': config_beach_decor, 'background': Color8(96, 213, 255)},
	TileTheme.FARM: {'tiles': config_farm, 'decor': config_farm_decor, 'background': Color8(236, 230, 204)},
	TileTheme.AUTUMN: {'tiles': config_autumn, 'decor': config_autumn_decor, 'background': Color8(254, 247, 219)},
}

@export var tile_theme: TileTheme = TileTheme.SUMMER

func get_tile(with_bridges: bool = true) -> TileInfo:
	var tile: TileInfo = config[tile_theme].tiles.pick_random()
	while (not with_bridges) and tile.bridge:
		tile = config[tile_theme].tiles.pick_random()
	return tile

func get_decorations() -> Array[TileDecorationsInfo]:
	var result: Array[TileDecorationsInfo] = []
	var _has_large = false
	var _seed = randi_range(0, 100)
	if _seed > 30:
		result.push_back(config[tile_theme].decor.pick_random())
		_has_large = result[0].size == TileDecorationsInfo.Size.LARGE
		if not _has_large and _seed > 70:
			result.push_back(config[tile_theme].decor.pick_random())
		elif result[0].size == TileDecorationsInfo.Size.THIN and result[0].oriented:
			result.push_back(result[0])
	return result

func get_background_color() -> Color:
	return config[tile_theme].background
