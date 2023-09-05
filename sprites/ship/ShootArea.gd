extends Node2D
@export var color: Color = Color(1, 0, 0, .01)
@export_range(5, 90) var angle: int = 17


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _draw():
	draw_circle_arc_poly(Vector2.ZERO, 250, 90, 90 - angle, color)
	draw_circle_arc_poly(Vector2.ZERO, 250, 90, 90 + angle, color)
	draw_circle_arc_poly(Vector2.ZERO, 250, -90, -90 + angle, color)
	draw_circle_arc_poly(Vector2.ZERO, 250, -90, -90 - angle, color)


func draw_circle_arc_poly(center: Vector2, radius: float, angle_from: float, angle_to: float, poly_color: Color):
	var nb_points = 32
	var points_arc = PackedVector2Array()
	points_arc.push_back(center)
	var colors = PackedColorArray([poly_color])

	for i in range(nb_points + 1):
		var angle_point = deg_to_rad(angle_from + i * (angle_to - angle_from) / nb_points - 90)
		points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radius)
		if points_arc.size() > 2:
			draw_polygon(points_arc, colors)
