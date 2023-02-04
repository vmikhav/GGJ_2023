extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_orientation(orientation: Tile.ORIENTATION):
	var need_flip = orientation == Tile.ORIENTATION.LEFT_UP
	if need_flip != $Sprite2D.flip_h:
		$Sprite2D.position.x = -$Sprite2D.position.x
	$Sprite2D.flip_h = need_flip
