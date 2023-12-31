extends CharacterBody2D
class_name Ship

var body_type: String = 'ship'

enum SHIP_STYLE {
	BLACK, RED, GREEN, YELLOW, BLUE, WHITE
}

var styles = {
	SHIP_STYLE.BLACK: {'full': Vector2i(408, 115), 'damaged_1': Vector2i(0, 307), 'damaged_2': Vector2i(272, 345)},
	SHIP_STYLE.RED: {'full': Vector2i(204, 115), 'damaged_1': Vector2i(0, 77), 'damaged_2': Vector2i(272, 230)},
	SHIP_STYLE.GREEN: {'full': Vector2i(68, 192), 'damaged_1': Vector2i(340, 345), 'damaged_2': Vector2i(272, 115)},
	SHIP_STYLE.YELLOW: {'full': Vector2i(68, 307), 'damaged_1': Vector2i(340, 115), 'damaged_2': Vector2i(204, 345)},
	SHIP_STYLE.BLUE: {'full': Vector2i(68, 77), 'damaged_1': Vector2i(340, 230), 'damaged_2': Vector2i(272, 0)},
	SHIP_STYLE.WHITE: {'full': Vector2i(408, 0), 'damaged_1': Vector2i(0, 192), 'damaged_2': Vector2i(340, 0)},
}

signal gem_reward(_reward, _position)
signal enemy_spooted
signal enemy_lost

@export var debug: bool = false
@export var controlled: bool = false
@export var speed: int = 400
@export var damage: int = 3
@export var reload_time: float = 1
@export var side_guns_count: int = 3
@export var nose_guns_count: int = 3
@export var max_health: int = 100
@export var max_crew: int = 6
@export var style: SHIP_STYLE = SHIP_STYLE.RED
@export var input_angle: int = 75
@export var max_turning_angle: int = 120
@export var max_acceleration: int = 300
@export var respawn_time: int = 20
@export var gem_price = 10
@onready var _follow: PathFollow2D = $Path2D/PathFollow2D
@onready var health: int = self.max_health
@onready var crew: int = self.max_crew
var follow_range: int = 700
var shot_range: int = 250
var style_mod: String = 'full'
var busy_crew: int = 0

@onready var agent = $NavigationAgent2D as NavigationAgent2D
@onready var crew_scene: PackedScene = preload("res://sprites/ship/Crew.tscn")
@onready var trash_scene: PackedScene = preload("res://sprites/ship/Trash.tscn")
@onready var dead_ship_scene: PackedScene = preload("res://sprites/ship/DeadShip.tscn")
@onready var boat_scene: PackedScene = preload("res://sprites/ship/Boat.tscn")
@onready var damage_number_template = preload("res://sprites/numbers/Damage_Number_2D.tscn")



var path_done = true
var pause_follow = false
var is_targeting = false
var target: Ship
var target_speed: float
var target_direction: float

var visible_enemies = {}
var damage_number_2d_pool:Array[DamageNumber2D] = []

# Called when the node enters the scene tree for the first time.
func _ready():
	set_style()
	_follow.position = position
	rotation = randf_range(-PI, PI)
	target_direction = rotation + PI / 2
	setup_attack_areas()
	if not controlled:
		if not Respawner.register(get_instance_id(), position, style, respawn_time):
			queue_free()
			return
		$FollowArea2D.body_entered.connect(_start_follow)
		$FollowArea2D.body_exited.connect(_end_follow)
		$AttackRangeArea2D.body_entered.connect(_start_target)
		$AttackRangeArea2D.body_exited.connect(_continue_follow)
		$AttackArea2D.body_entered.connect(_start_attack)
		$AttackArea2D.body_exited.connect(_start_target)
		$AttackArea2D2.body_entered.connect(_start_attack)
		$AttackArea2D2.body_exited.connect(_start_target)
		$AttackArea2D3.body_entered.connect(_start_attack)
		$AttackArea2D3.body_exited.connect(_start_target)
		$FollowTimer.timeout.connect(_update_follow)
	else:
		$FollowArea2D.body_entered.connect(_start_follow)
		$FollowArea2D.body_exited.connect(_end_follow)
	
	agent.velocity_computed.connect(on_velocity_computed)
	agent.target_reached.connect(on_target_reached)

func set_style(mod: String = 'full'):
	var rect = Rect2(styles[style][mod], $Sprite2D.region_rect.size)
	$Sprite2D.region_rect = rect

func setup_attack_areas():
	$AttackArea2D.damage = damage
	$AttackArea2D.guns_number = side_guns_count
	$AttackArea2D.reload_time = reload_time
	$AttackArea2D2.damage = damage
	$AttackArea2D2.guns_number = nose_guns_count
	$AttackArea2D2.reload_time = reload_time
	$AttackArea2D3.damage = damage
	$AttackArea2D3.guns_number = side_guns_count
	$AttackArea2D3.reload_time = reload_time

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if controlled:
		var _input_vector = Input.get_vector("move_left", "move_right", "move_up", "move_down")
		if _input_vector.x == 0 and _input_vector.y == 0:
			target_speed = 0
			is_targeting = false
			return

		var _direction = rotation + PI/2
		var _angle_difference = angle_difference(_input_vector.angle(), _direction)
		var _abs_angle_difference = absf(_angle_difference)
		
		is_targeting = true
		target_speed = 3 * speed / 4
		var _rotation_multiplier: float = 1
		if _abs_angle_difference > 3 * PI / 4:
			target_speed = speed / 3
			_rotation_multiplier = 0.75
		elif _abs_angle_difference > PI / 4:
			target_speed = speed
			_rotation_multiplier = 0.55
		
		target_speed *= _input_vector.length()
		
		if _abs_angle_difference > PI / 64:
			if _angle_difference < 0:
				_direction += (input_angle * PI / 180) * _rotation_multiplier * delta
			else:
				_direction -= (input_angle * PI / 180) * _rotation_multiplier * delta
		
		target_direction = _direction


func _physics_process(delta: float) -> void:
	if not path_done and not pause_follow and not agent.is_navigation_finished():
		var next_location = agent.get_next_path_position()
		if debug:
			print('go to ', next_location)
		var v = (next_location - global_position).normalized()
		agent.set_velocity(v * speed)
		target_speed = speed
		update_velocity(delta)
	if controlled:
		update_velocity(delta)
	if is_targeting and not controlled:
		update_velocity(delta)

func on_velocity_computed(safe_velocity: Vector2) -> void:
	if not path_done and not pause_follow and not agent.is_navigation_finished():
		target_direction = safe_velocity.angle()
		if debug:
			print('calc velocity: ', target_direction / PI * 180, ' ', (rotation + PI / 2) / PI * 180)

func on_target_reached() -> void:
	path_done = true
	target_speed = 0

func navigate(_target: Vector2):
	if _target.distance_squared_to(position) < 50*50:
		return
	
	if debug:
		print('move to ', _target)
	agent.set_target_position(_target)
	target_speed = speed
	is_targeting = false
	path_done = false

func navigate_shot_range(_target: Vector2):
	var _target_direction = _target.direction_to(position)
	var _distance = _target.distance_to(position)
	var _navigation_distance = _distance - (3 * shot_range / 4)
	var _direction = Vector2(randi_range(-30, 30), randi_range(-30, 30)).normalized()
	
	navigate(_target + ((_direction + _target_direction).normalized() * _navigation_distance))

func update_velocity(delta: float):
	var _current_direction = rotation + PI / 2
	var _new_direction = _current_direction
	var _direction_difference = angle_difference(_current_direction, target_direction)
	var _direction_delta = (max_turning_angle * PI / 180) * delta
	if target_speed > 0 and abs(_direction_difference) > PI / 4:
		target_speed = speed / 5
	
	var _current_speed = velocity.length()
	var _new_speed = _current_speed
	var _speed_delta = max_acceleration * delta
	if absf(_current_speed - target_speed) < _speed_delta:
		_new_speed = target_speed
	else:
		_new_speed += _speed_delta if _current_speed < target_speed else -_speed_delta

	if abs(_direction_difference) < _direction_delta:
		_new_direction = target_direction
	else:
		_new_direction += _direction_delta if _direction_difference > 0 else -_direction_delta
	velocity = Vector2(cos(_new_direction), sin(_new_direction)) * _new_speed
	rotation = _new_direction - PI / 2
	if move_and_slide():
		velocity = Vector2(cos(_new_direction), sin(_new_direction)) * 100 * delta

func _start_follow(_body):
	if is_enemy_ship(_body):
		if not visible_enemies.size():
			enemy_spooted.emit()
		visible_enemies[_body.get_instance_id()] = 1

func _end_follow(_body):
	if is_enemy_ship(_body):
		visible_enemies.erase(_body.get_instance_id())
		if not visible_enemies.size():
			enemy_lost.emit()

func _start_target(_body):
	if is_enemy_ship(_body):
		visible_enemies[_body.get_instance_id()] = 2
		if not controlled:
			pause_follow = true
		is_targeting = true
		var _vector = position - _body.position
		var _perpendicular = Vector2(_vector.y, -_vector.x)
		var _angle = abs(rotation_degrees - _body.rotation_degrees)
		if _angle > 150 and _angle < 200:
			_perpendicular = _perpendicular - _vector / 2
		target_speed = speed / 2
		target_direction = _perpendicular.angle()
		if debug:
			print(target_direction)

func _continue_follow(_body):
	if is_enemy_ship(_body):
		visible_enemies[_body.get_instance_id()] = 1

func _start_attack(_body):
	if is_enemy_ship(_body):
		visible_enemies[_body.get_instance_id()] = 3

func _update_follow():
	is_targeting = false
	if target and (not is_instance_valid(target) or not visible_enemies.has(target.get_instance_id())):
		target = null
	for _id in visible_enemies:
		if not is_instance_id_valid(_id):
			visible_enemies.erase(_id)
			if not visible_enemies.size():
				enemy_lost.emit()
		elif not target or visible_enemies[target.get_instance_id()] < visible_enemies[_id]:
			target = instance_from_id(_id)
	if target:
		var _priority = visible_enemies[target.get_instance_id()]
		if debug:
			print('target priority: ', _priority)
		if not controlled and _priority == 1:
			pause_follow = false
			if debug:
				print('come closer to ', target.position)
			navigate_shot_range(target.position)
		if _priority == 2 and (not controlled or path_done):
			#pause_follow = true
			if debug:
				print('start target to ', target.position)
			_stop_navigation()
			_start_target(target)
		if _priority == 3:
			if debug:
				print('shooting')
			_stop_navigation()
	elif not controlled:
		if debug:
			print('stop')
		_stop_navigation()

func _stop_navigation():
	agent.set_target_position(position)
	velocity = Vector2.ZERO
	path_done = true
	target_speed = 0

func get_damage(_damage: int, _target: Vector2, _direction: Vector2):
	if health <= 0:
		return
	
	var _old_health = health
	health = max(health - _damage, 0)
	var _new_style = _get_style_mod()
	if style_mod != _new_style:
		set_style(_new_style)
	
	if (_damage == 0):
		return
	
	spawn_damage_number(_damage, 'damage')
	
	if crew > 1 and randi_range(1, 100) > 80:
		var _crew = crew_scene.instantiate() as Node2D
		_crew.position = _target
		var _fall_direction = _direction
		get_parent().add_child(_crew)
		var _fall_target = _target + _fall_direction * randf_range(50, 80)
		_fall_target = _fall_target + Vector2(randi_range(-40, 40), 0).rotated(rotation)
		_crew.set_target(_fall_target)
		crew -= 1
	
	if randi_range(1, 100) > 20:
		var _trash = trash_scene.instantiate() as Node2D
		_trash.position = _target
		var _fall_direction = _direction
		get_parent().add_child(_trash)
		var _fall_target = _target + _fall_direction * randf_range(40, 80)
		_fall_target = _fall_target + Vector2(randi_range(-40, 40), 0).rotated(rotation)
		_trash.set_target(_fall_target)
	
	if debug:
		print(health)
	if _old_health and health == 0:
		if controlled:
			health = max_health
			set_style(_get_style_mod())
			position = PlayerStats.get_ship_respawn_pos()
			return true
		else:
			if debug:
				print('death')
			$FollowTimer.stop()
			_stop_navigation()
			var _dead = dead_ship_scene.instantiate() as Node2D
			_dead.position = position
			_dead.rotation = rotation
			_dead.style = style
			get_parent().add_child(_dead)
			var _boat = boat_scene.instantiate() as Node2D
			_boat.position = position + Vector2(randi_range(-10, 10), randi_range(-10, 10))
			_boat.rotation = rotation + randf_range(-PI/2, PI/2)
			_boat.direction = Vector2(cos(_boat.rotation+PI/2), sin(_boat.rotation+PI/2))
			get_parent().add_child(_boat)
			Respawner.mark_dead(get_instance_id())
			queue_free()
	return health == 0

func heal(_heal: int):
	spawn_damage_number(_heal, 'heal')
	health = min(health + _heal, max_health)
	var _new_style = _get_style_mod()
	if style_mod != _new_style:
		set_style(_new_style)

func _get_style_mod():
	var percent_health = health * 100 / max_health
	if percent_health < 30:
		return 'damaged_2'
	if percent_health < 75:
		return 'damaged_1'
	return 'full'

func onboard_crew(number: int = 1) -> void:
	crew = mini(max_crew, crew + number)

func request_crew(number: int) -> int:
	var _available = max(0, crew - busy_crew)
	_available = mini(number, _available)
	busy_crew += _available
	return _available

func release_crew(number: int) -> void:
	busy_crew = max(0, busy_crew - number)

func see_enemies() -> bool:
	for _body in $FollowArea2D.get_overlapping_bodies():
		if is_enemy_ship(_body):
			return true
	return false

func loot_ship(_reward, _position):
	if controlled:
		PlayerStats.add_gems(_reward)
		gem_reward.emit(_reward, _position)

func is_ship(_body) -> bool:
	return _body.is_class("CharacterBody2D") and _body.body_type == 'ship'

func is_enemy_ship(_body) -> bool:
	return is_ship(_body) and _body.style != style

func spawn_damage_number(value: float, _type: String):
	var damage_number = get_damage_number()	
	var _val = str(round(value))
	get_parent().add_child(damage_number)
	damage_number.position = position + Vector2(0, randi_range(-60, -40))
	damage_number.z_index = 400
	var _color: Color
	var _animation_speed = 1
	if _type == 'damage':
		_color = Color8(255, 0, 0)
	elif _type == 'heal':
		_color = Color8(91, 127, 0)
	elif _type == 'gems':
		_color = Color8(255, 216, 0)
		_animation_speed = 0.25
	damage_number.set_values_and_animate(_val, Vector2(0, 0), 80, 60, _color, _animation_speed)
	if debug:
		print(damage_number)

func get_damage_number() -> DamageNumber2D:
	var _new_damage_number = damage_number_template.instantiate()
	return _new_damage_number
