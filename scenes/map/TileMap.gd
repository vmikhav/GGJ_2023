extends TileMap

var click_position: Vector2
var touch_events = false

signal click(position: Vector2)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	# Mouse in viewport coordinates.
	if event is InputEventScreenTouch:
		touch_events = true
		if event.pressed:
			click_position = event.position
		elif click_position.distance_squared_to(event.position) < 50:
			var trans = get_global_transform_with_canvas()
			click.emit((event.position - trans.origin) / trans.x.x)
	
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not touch_events:
		if event.pressed:
			click_position = event.position
		elif click_position.distance_squared_to(event.position) < 50:
			var trans = get_global_transform_with_canvas()
			click.emit((event.position - trans.origin) / trans.x.x)
