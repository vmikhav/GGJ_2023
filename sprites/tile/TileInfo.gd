class_name TileInfo
extends RefCounted

var path: String
var thin: bool
var bridge: bool
var decorate_edge: bool
var decorate_center: bool


func _init(_path: String, _thin: bool, _bridge: bool, _decorate_egde: bool, _decorate_center: bool):
	path = _path
	thin = _thin
	bridge = _bridge
	decorate_edge = _decorate_egde
	decorate_center = _decorate_center
