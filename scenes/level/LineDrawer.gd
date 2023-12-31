extends Node2D

@export_node_path("Node2D") var recognizer: NodePath
var _recognizer: Recognizer
@export var can_draw: bool = true
@export var color: Color = Color(1, 1, 1)

# Called when the node enters the scene tree for the first time.
func _ready():
	_recognizer = get_node(recognizer) as Recognizer
	_recognizer.redraw.connect(queue_redraw)


func _draw():
	if can_draw and _recognizer.points.size() >= 2:
		draw_circle(_recognizer.points[0], 12, color)
		draw_circle(_recognizer.points[-1], 12, color)
		draw_polyline(_recognizer.points, color, 24, true)
