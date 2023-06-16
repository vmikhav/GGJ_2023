class_name TileDecorationsInfo
extends RefCounted

enum Size {
	THIN, SMALL, LARGE
}

var path: String
var size: Size
var oriented: bool


func _init(_path: String, _size: Size, _oriented: bool):
	path = _path
	size = _size
	oriented = _oriented
