extends CharacterBody2D
class_name Ship

enum SHIP_STYLE {
	BLACK, RED, GREEN, YELLOW, BLUE, WHITE
}

var styles = {
	SHIP_STYLE.BLACK: {'full': Vector2i(408, 115)},
	SHIP_STYLE.RED: {'full': Vector2i(204, 115)},
	SHIP_STYLE.GREEN: {'full': Vector2i(68, 192)},
	SHIP_STYLE.YELLOW: {'full': Vector2i(68, 307)},
	SHIP_STYLE.BLUE: {'full': Vector2i(68, 77)},
	SHIP_STYLE.WHITE: {'full': Vector2i(408, 0)},
}

@export var controlled: bool = false
@export var speed: int = 500
@export var damage: int = 5
@export var max_health: int = 100
@export var style: SHIP_STYLE = SHIP_STYLE.RED
@onready var _follow: PathFollow2D = $Path2D/PathFollow2D
@onready var health: int = self.max_health
var path_done = true
var pause_follow = false
var is_targeting = false
var target: Ship
var target_velocity: Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	_follow.position = position
	var rect = Rect2(styles[style].full, $Sprite2D.region_rect.size)
	$Sprite2D.region_rect = rect
	if not controlled:
		$FollowArea2D.body_entered.connect(_start_follow)
		$FollowArea2D.body_exited.connect(_end_follow)
		$AttackRangeArea2D.body_entered.connect(_start_target)
		$AttackRangeArea2D.body_exited.connect(_continue_follow)
		$AttackArea2D.body_entered.connect(_start_attack)
		$AttackArea2D.body_exited.connect(_start_target)
		$FollowTimer.timeout.connect(_update_follow)
	$AttackTimer.timeout.connect(_update_attack)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not path_done and not pause_follow: 
		if _follow.progress_ratio < 1:
			_follow.set_progress(_follow.get_progress() + speed * delta)
			velocity = normalize_velocity((_follow.position - position).normalized()) * speed
			move_and_slide()
			rotation = (5 * velocity + get_real_velocity()).angle() - PI / 2
		else:
			path_done = true
	if is_targeting:
		velocity = normalize_velocity(target_velocity) * speed
		move_and_slide()
		rotation = (5 * velocity + get_real_velocity()).angle() - PI / 2
	#if position.distance_squared_to(target) > 50:
	#	$Sprite2D.rotation = position.angle_to_point(target) - PI / 2
	#	var vec = target - self.position # getting the vector from self to the mouse
	#	vec = vec.normalized() * delta * speed # normalize it and multiply by time and speed
	#	position += vec # move by that vector

func navigate(_target: Vector2):
	if _target.distance_squared_to(position) < 75*75:
		return
	# prepare query objects
	var query_parameters = NavigationPathQueryParameters2D.new()
	var query_result  = NavigationPathQueryResult2D.new()

	# update parameters object
	query_parameters.map = get_world_2d().get_navigation_map()
	query_parameters.start_position = position
	query_parameters.target_position = _target
	query_parameters.navigation_layers = 1

	# update result object
	NavigationServer2D.query_path(query_parameters, query_result)
	var path: PackedVector2Array = query_result.get_path()
	var curve: Curve2D = Curve2D.new()
	for point in path:
		curve.add_point(point)
	_follow.progress_ratio = 0
	
	$Path2D.curve = curve
	path_done = false

func navigate_shot_range(_target: Vector2):
	var _target_direction = _target.direction_to(position)
	var _direction = Vector2(randi_range(-30, 30), randi_range(-30, 30)).normalized()
	navigate(_target + ((_direction + _target_direction).normalized() * 150))

func normalize_velocity(_target_velocity: Vector2):
	var _normalized = velocity.normalized()
	if absf(_normalized.angle_to(_target_velocity)) > PI / 8:
		return (3 * _normalized + _target_velocity).normalized()
	return _target_velocity

func _start_follow(_body):
	if _body.is_class("CharacterBody2D") and _body.controlled:
		target = _body
		navigate_shot_range(target.position)

func _end_follow(_body):
	if _body.is_class("CharacterBody2D") and _body.controlled:
		target = null
		path_done = true
		pause_follow = false

func _start_target(_body):
	if _body.is_class("CharacterBody2D") and _body.controlled:
		pause_follow = true
		is_targeting = true
		var _vector = position - target.position
		var _perpendicular = Vector2(_vector.y, -_vector.x)
		target_velocity = _perpendicular.normalized()

func _continue_follow(_body):
	if _body.is_class("CharacterBody2D") and _body.controlled:
		pause_follow = false
		is_targeting = false

func _start_attack(_body):
	if _body.is_class("CharacterBody2D") and _body.controlled:
		is_targeting = false
		velocity = Vector2.ZERO

func _update_follow():
	if target and not pause_follow and target.position.distance_squared_to(position) > 250*250:
		navigate_shot_range(target.position)
	if target and is_targeting:
		_start_target(target)

func _update_attack():
	if $AttackArea2D.has_overlapping_bodies():
		var bodies = $AttackArea2D.get_overlapping_bodies()
		for _body in bodies:
			if _body.is_class("CharacterBody2D") and _body.controlled != controlled:
				if _body.get_damage(damage):
					target = null
					pause_follow = false
				return

func get_damage(_damage: int):
	health = max(health - _damage, 0)
	print(health)
	if health == 0:
		queue_free()
	return health == 0
