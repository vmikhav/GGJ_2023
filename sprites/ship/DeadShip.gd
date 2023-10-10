extends Node2D

var style: Ship.SHIP_STYLE

# Called when the node enters the scene tree for the first time.
func _ready():
	sunk()

func sunk():
	var tween = get_tree().create_tween()
	tween.tween_interval(1.5)
	tween.tween_property(self, "modulate", Color(0, 0.612, 1, 0.35), .5)
	tween.tween_property(self, "modulate", Color(0, 0.612, 1, 0), 1)
	tween.finished.connect(queue_free)
