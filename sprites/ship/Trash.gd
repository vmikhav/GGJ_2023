extends Node2D

var positionA: Vector2 = Vector2(0, 0)
var positionB: Vector2 = Vector2(0, 0)
var positionC: Vector2 = Vector2(0, 0)
var t: float = 0
var duration = 1.0

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite2D.rotation = randf_range(0, PI)

func set_target(target_position: Vector2):
	positionA = position
	positionB = target_position
	positionC = Vector2((positionB.x * 2 + positionA.x * 1) / 3, positionB.y - 70)
	var tween = get_tree().create_tween()
	tween.tween_interval(duration + 1.5)
	tween.tween_property(self, "modulate", Color(0, 0.612, 1, 0.35), .5)
	tween.tween_property(self, "modulate", Color(0, 0.612, 1, 0), 1)
	tween.finished.connect(queue_free)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	t += delta / duration
	var q0 = positionA.lerp(positionC, min(t, 1.0))
	var q1 = positionC.lerp(positionB, min(t, 1.0))
	position = q0.lerp(q1, min(t, 1.0))
