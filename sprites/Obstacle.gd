class_name Obstacle
extends Node2D

var symbols: Array[Obstacle.SYMBOL] = []
var tile: Tile

enum SYMBOL {
	H_LINE, V_LINE, CARET_UP, CARET_DOWN, LIGHTNING, CARET_LEFT, CARET_RIGHT, CIRCLE,
}

var symbols_map = {
	Obstacle.SYMBOL.H_LINE: [Recognizer.SYMBOL.H_LINE_L, Recognizer.SYMBOL.H_LINE_R],
	Obstacle.SYMBOL.V_LINE: [Recognizer.SYMBOL.V_LINE_D, Recognizer.SYMBOL.V_LINE_U],
	Obstacle.SYMBOL.CARET_UP: [Recognizer.SYMBOL.CARET_UP_L, Recognizer.SYMBOL.CARET_UP_R],
	Obstacle.SYMBOL.CARET_DOWN: [Recognizer.SYMBOL.CARET_DOWN_L, Recognizer.SYMBOL.CARET_DOWN_R],
	Obstacle.SYMBOL.LIGHTNING: [Recognizer.SYMBOL.LIGHTNING],
	Obstacle.SYMBOL.CARET_LEFT: [Recognizer.SYMBOL.CARET_LEFT_D, Recognizer.SYMBOL.CARET_LEFT_U],
	Obstacle.SYMBOL.CARET_RIGHT: [Recognizer.SYMBOL.CARET_RIGHT_D, Recognizer.SYMBOL.CARET_RIGHT_U],
	Obstacle.SYMBOL.CIRCLE: [Recognizer.SYMBOL.CIRCLE_L, Recognizer.SYMBOL.CIRCLE_R],
}

func set_symbols(_symbols: Array[Obstacle.SYMBOL]):
	symbols = _symbols
	update_view()


func apply_symbol(symbol: Recognizer.SYMBOL) -> bool:
	var _result = false
	
	if symbols.size() and symbols_map[symbols[0]].has(symbol):
		_result = true
		symbols.remove_at(0)
	
	if not symbols.size():
		remove()
	elif _result:
		update_view()
	
	return _result

func update_view():
	pass

func remove():
	tile.obstacle = null
	queue_free()
