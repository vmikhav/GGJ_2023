extends Obstacle

var offsets = {
	Obstacle.SYMBOL.H_LINE: Vector2(0, 95),
	Obstacle.SYMBOL.V_LINE: Vector2(0, 0),
	Obstacle.SYMBOL.CARET_UP: Vector2(0, 285),
	Obstacle.SYMBOL.CARET_DOWN: Vector2(0, 190),
	Obstacle.SYMBOL.LIGHTNING: Vector2(58, 95),
	Obstacle.SYMBOL.CARET_LEFT: Vector2(0, 380),
	Obstacle.SYMBOL.CARET_RIGHT: Vector2(58, 0),
	Obstacle.SYMBOL.CIRCLE: Vector2(58, 285),
}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func update_view(initial: bool = false):
	if not symbols.size():
		return
	var texture = $Sprite2D.texture as AtlasTexture
	texture.region.position = offsets[symbols[0]]
	if initial:
		return
	var _duration = 0.5
	var _next_tile: Tile = tile.next_tile
	if _next_tile and not _next_tile.obstacle:
		if randi_range(0, 1) and _next_tile.next_tile and not _next_tile.next_tile.obstacle:
			_next_tile = _next_tile.next_tile
			_duration += 0.5
		_next_tile.obstacle = tile.obstacle
		tile.obstacle = null
		var old_tile = tile
		tile = _next_tile
		var new_position = position + tile.position - old_tile.position
		var tween = create_tween()
		tween.tween_property(self, "position", new_position, _duration).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	var opacity_tween = create_tween()
	opacity_tween.tween_property(self, "modulate", Color8(255, 255, 255, 150), 0.25)
	opacity_tween.tween_property(self, "modulate", Color8(255, 255, 255, 255), 0.35).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)

func remove():
	tile.obstacle = null
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color8(255, 255, 255, 0), 0.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	await tween.finished
	queue_free()
	
