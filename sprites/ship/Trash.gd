extends Node2D

var positionA: Vector2 = Vector2(0, 0)
var positionB: Vector2 = Vector2(0, 0)
var positionC: Vector2 = Vector2(0, 0)
var t: float = 0
var duration = 1.0

var styles = [
	{"pos": Vector2(408, 472), "size": Vector2(26, 10)},
	{"pos": Vector2(88, 440), "size": Vector2(26, 7)},
	{"pos": Vector2(88, 449), "size": Vector2(15, 7)},
	{"pos": Vector2(116, 440), "size": Vector2(15, 10)},
]

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite2D.rotation = randf_range(0, PI)
	var _style = styles.pick_random()
	print(_style)
	$Sprite2D.region_rect = Rect2(_style.pos, _style.size)
	get_tree().create_timer(duration + 1).timeout.connect(func ():
		$Area2D.body_entered.connect(check_ship)
	)

func set_target(target_position: Vector2):
	positionA = position
	positionB = target_position
	positionC = Vector2((positionB.x * 2 + positionA.x * 1) / 3, positionB.y - 70)
	var tween = get_tree().create_tween()
	tween.tween_interval(duration + 3.5)
	tween.tween_property(self, "modulate", Color(0, 0.612, 1, 0.35), .5)
	tween.tween_interval(3.5)
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

func check_ship(_body):
	if is_ship(_body):
		var _ship = _body as Ship
		_ship.heal(5)
		queue_free()

func is_ship(_body) -> bool:
	return _body.is_class("CharacterBody2D") and _body.body_type == 'ship'
