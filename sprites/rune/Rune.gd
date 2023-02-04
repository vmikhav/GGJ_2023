extends Obstacle

var offsets = {
	Obstacle.SYMBOL.H_LINE: Vector2(0, 95),
	Obstacle.SYMBOL.V_LINE: Vector2(0, 0),
	Obstacle.SYMBOL.CARET_UP: Vector2(0, 285),
	Obstacle.SYMBOL.CARET_DOWN: Vector2(0, 190),
}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func update_view():
	if not symbols.size():
		return
	var texture = $Sprite2D.texture as AtlasTexture
	texture.region.position = offsets[symbols[0]]

func remove():
	tile.obstacle = null
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color8(255, 255, 255, 0), 0.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT) 
	await tween.finished
	queue_free()
