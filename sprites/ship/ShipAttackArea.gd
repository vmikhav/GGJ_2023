extends Area2D

@export var guns_number: int = 3
@export var damage: int = 500
@export var reload_time: float = 1:
	set(time):
		reload_time = time
		($AttackTimer as Timer).wait_time = reload_time

@onready var parent: Ship = get_parent()
@onready var bullet_scene: PackedScene = preload("res://sprites/ship/Bullet.tscn")
@onready var smoke_scene: PackedScene = preload("res://sprites/ship/Smoke.tscn")

var is_charged = false
var busy_crew: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	body_entered.connect(_start_attack)
	($AttackTimer as Timer).wait_time = reload_time
	$AttackTimer.paused = true
	get_tree().create_timer(randf_range(0.05, 0.5)).timeout.connect(func ():
		$AttackTimer.paused = false
	)
	$AttackTimer.timeout.connect(_attack)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _start_attack(_body):
	if is_charged:
		_attack()
		$AttackTimer.start()

func _attack():
	is_charged = true
	if busy_crew:
		parent.release_crew(busy_crew)
		busy_crew = 0
	if parent.health <= 0:
		$AttackTimer.stop()
		return
	if has_overlapping_bodies():
		var bodies = get_overlapping_bodies()
		for _body in bodies:
			if is_enemy_ship(_body):
				busy_crew = parent.request_crew(guns_number)
				if not busy_crew:
					return
				is_charged = false
				for i in busy_crew:
					shot(_body)
				return

func shot(_body):
	var _bullet = bullet_scene.instantiate() as Node2D
	var _smoke = smoke_scene.instantiate() as Node2D
	var _start_position = parent.position + Vector2(0, randi_range(-40, 40)).rotated(parent.rotation)
	_bullet.position = _start_position
	_smoke.position = _start_position
	var _target = _body.position + Vector2(0, randi_range(-30, 30)).rotated(_body.rotation)
	_smoke.rotation = _smoke.position.angle_to_point(_target)
	_smoke.z_index = 200
	var _duration = _bullet.set_target(_target)
	_target += _body.velocity * _duration * .5
	_duration = _bullet.set_target(_target)
	parent.get_parent().add_child(_bullet)
	parent.get_parent().add_child(_smoke)
	var _potential_reward = _body.gem_price
	get_tree().create_timer(_duration).timeout.connect(func():
		if is_instance_valid(_body) and _target.distance_squared_to(_body.position) < 900:
			var _attack_direction = (_target - _start_position).normalized()
			if _body.get_damage(damage, _target, _attack_direction):
				body_exited.emit(_body)
				parent.loot_ship(_potential_reward)
	)
	get_tree().create_timer(1.5).timeout.connect(func():
		if is_instance_valid(_smoke):
			_smoke.queue_free()
	)

func is_ship(_body) -> bool:
	return _body.is_class("CharacterBody2D") and _body.body_type == 'ship'

func is_enemy_ship(_body) -> bool:
	return is_ship(_body) and _body.style != parent.style
