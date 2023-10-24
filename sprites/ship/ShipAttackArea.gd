extends Area2D

@export var guns_number: int = 1
@export var damage: int = 500

@onready var parent: Ship = get_parent()
@onready var bullet_scene: PackedScene = preload("res://sprites/ship/Bullet.tscn")
@onready var smoke_scene: PackedScene = preload("res://sprites/ship/Smoke.tscn")

var is_charged = false

# Called when the node enters the scene tree for the first time.
func _ready():
	body_entered.connect(_start_attack)
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
	if parent.health <= 0:
		$AttackTimer.stop()
		return
	if has_overlapping_bodies():
		var bodies = get_overlapping_bodies()
		for _body in bodies:
			if is_enemy_ship(_body):
				is_charged = false
				var _bullet = bullet_scene.instantiate() as Node2D
				var _smoke = smoke_scene.instantiate() as Node2D
				var _start_position = parent.position + Vector2(0, randi_range(-40, 40)).rotated(parent.rotation)
				_bullet.position = _start_position
				_smoke.position = _start_position
				var _target = _body.position + Vector2(0, randi_range(-40, 40)).rotated(_body.rotation)
				_smoke.rotation = _smoke.position.angle_to_point(_target)
				_smoke.z_index = 200
				var _duration = _bullet.set_target(_target)
				parent.get_parent().add_child(_bullet)
				parent.get_parent().add_child(_smoke)
				get_tree().create_timer(_duration).timeout.connect(func():
					if is_instance_valid(_body) and _target.distance_squared_to(_body.position) < 600:
						var _attack_direction = (_target - _start_position).normalized()
						if _body.get_damage(damage, _target, _attack_direction):
							body_exited.emit(_body)
				)
				get_tree().create_timer(1.5).timeout.connect(func():
					if is_instance_valid(_smoke):
						_smoke.queue_free()
				)
				return

func is_ship(_body) -> bool:
	return _body.is_class("CharacterBody2D") and _body.body_type == 'ship'

func is_enemy_ship(_body) -> bool:
	return is_ship(_body) and _body.style != parent.style
