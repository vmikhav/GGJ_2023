extends CharacterBody2D

var body_type: String = 'boat'
var direction: Vector2
@export var max_speed: float = 50
@export var min_speed: float = 30
var speed: float

func _ready():
	speed = max_speed
	$Area2D.body_entered.connect(check_ship)
	$Timer.timeout.connect(remove)

func _physics_process(delta):
	speed -= delta * 20
	if speed < min_speed:
		speed = max_speed
	velocity = direction * speed
	move_and_slide()
	if get_real_velocity().length_squared() < 400:
		remove()

func check_ship(_body):
	if is_ship(_body):
		var _ship = _body as Ship
		_ship.heal(15)
		_ship.onboard_crew(randi_range(1,3))
		remove()

func remove():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate", Color8(255, 255, 255, 0), .5)
	await tween.finished
	queue_free()

func is_ship(_body) -> bool:
	return _body.is_class("CharacterBody2D") and _body.body_type == 'ship'
