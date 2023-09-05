extends Node2D

var target_position: Vector2i
var start_position: Vector2
var duration: float
var t: float = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_target(target: Vector2i) -> float:
	target_position = target
	start_position = position
	duration = position.distance_to(target_position) / 750
	return duration


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	t += delta / duration
	position = start_position.lerp(target_position, min(t, 1.0))
	if t >= 1:
		queue_free()
