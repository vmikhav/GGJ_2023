extends Node2D

@export var controlled: bool = false
@export var speed: int = 500
@onready var _follow: PathFollow2D = $Path2D/PathFollow2D
var path_done = true


# Called when the node enters the scene tree for the first time.
func _ready():
	_follow.position = position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not path_done: 
		if _follow.progress_ratio < 1:
			_follow.set_progress(_follow.get_progress() + speed * delta)
			$Sprite2D.rotation = _follow.rotation - PI / 2
			position = _follow.position
		else:
			path_done = true
	#if position.distance_squared_to(target) > 50:
	#	$Sprite2D.rotation = position.angle_to_point(target) - PI / 2
	#	var vec = target - self.position # getting the vector from self to the mouse
	#	vec = vec.normalized() * delta * speed # normalize it and multiply by time and speed
	#	position += vec # move by that vector

func navigate(_target: Vector2):
	# prepare query objects
	var query_parameters = NavigationPathQueryParameters2D.new()
	var query_result  = NavigationPathQueryResult2D.new()

	# update parameters object
	query_parameters.map = get_world_2d().get_navigation_map()
	query_parameters.start_position = _follow.position
	query_parameters.target_position = _target
	query_parameters.navigation_layers = 1

	# update result object
	NavigationServer2D.query_path(query_parameters, query_result)
	var path: PackedVector2Array = query_result.get_path()
	var curve = Curve2D.new()
	for point in path:
		curve.add_point(point)
	_follow.progress_ratio = 0
	
	$Path2D.curve = curve
	path_done = false
	
	
	#target = _target
