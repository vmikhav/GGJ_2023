extends Node2D

@export_node_path("Node2D") var recognizer: NodePath
var _recognizer: Recognizer
@export var can_draw: bool = true

# Called when the node enters the scene tree for the first time.
func _ready():
	_recognizer = get_node(recognizer) as Recognizer
	_recognizer.connect("redraw", queue_redraw)


func _draw():
	if can_draw and _recognizer.points.size() >= 2:
		draw_circle(_recognizer.points[0], 12, Color8(255, 255, 255))
		draw_circle(_recognizer.points[-1], 12, Color8(255, 255, 255))
		draw_polyline(_recognizer.points, Color8(255, 255, 255), 24, true)
