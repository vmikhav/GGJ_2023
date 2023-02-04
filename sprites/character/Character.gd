extends Node2D

var current_tile: Tile

var positionA: Vector2 = Vector2(0, 0)
var positionB: Vector2 = Vector2(0, 0)
var positionC: Vector2 = Vector2(0, 0)

var t: float = 0
var duration: float = 1.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if positionA.x == 0:
		return
	t += delta / duration
	var q0 = positionA.lerp(positionC, min(t, 1.0))
	var q1 = positionC.lerp(positionB, min(t, 1.0))
	position = q0.lerp(q1, min(t, 1.0))

func set_tile(tile: Tile) -> void:
	current_tile = tile
	set_orientation(tile.orientation)
	position = current_tile.position
	
	positionA = current_tile.position
	positionB = current_tile.next_tile.position
	positionC = current_tile.next_tile.position

func set_orientation(orientation: Tile.ORIENTATION):
	var need_flip = orientation == Tile.ORIENTATION.LEFT_UP
	if need_flip != $Sprite2D.flip_h:
		$Sprite2D.position.x = -$Sprite2D.position.x
	$Sprite2D.flip_h = need_flip
