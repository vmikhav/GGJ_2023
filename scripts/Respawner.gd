extends Node

var scene: Node
var data = {}

func set_scene(_scene: Node) -> void:
	scene = _scene

func register(_id: int, _position: Vector2, style: Ship.SHIP_STYLE) -> bool:
	var _time = Time.get_ticks_msec()
	if data.has(_position):
		if data[_position].has('death') and data[_position]['death'] > _time - 180000:
			return false
	data[_position] = {'id': _id}
	return true

func mark_dead(_id: int):
	for key in data.keys():
		if data[key]['id'] == _id:
			data[key]['death'] = Time.get_ticks_msec()
