extends Node2D

var style: Ship.SHIP_STYLE

# Called when the node enters the scene tree for the first time.
func _ready():
	$Explosion/AnimationPlayer.play("explosion")
	$Timer.timeout.connect(func ():
		$Explosion/AnimationPlayer.stop()
		$Explosion.hide()
		sunk()
	)

func sunk():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate", Color(0, 0.612, 1, 0.35), 1.5)
	tween.tween_interval(5.5)
	tween.tween_property(self, "modulate", Color(0, 0.612, 1, 0), 5)
	tween.finished.connect(queue_free)
