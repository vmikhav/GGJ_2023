extends Node2D

var regions = [
	Vector2(439, 472), Vector2(463, 489), Vector2(487, 489),
	Vector2(511, 489), Vector2(544, 469), Vector2(568, 469),
]

var positionA: Vector2 = Vector2(0, 0)
var positionB: Vector2 = Vector2(0, 0)
var positionC: Vector2 = Vector2(0, 0)
var t: float = 0
var duration = 1.5

# Called when the node enters the scene tree for the first time.
func _ready():
	var rect = Rect2(regions.pick_random(), $Sprite2D.region_rect.size)
	$Sprite2D.region_rect = rect
	if randi_range(1, 10) > 5:
		$Sprite2D.flip_h = true

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
