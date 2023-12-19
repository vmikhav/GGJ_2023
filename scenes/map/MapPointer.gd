extends Node2D
class_name MapPointer

enum PointerType {
	LEVEL, SHOP
}

@export_node_path("Area2D") var target_area
@export var type: PointerType

# Called when the node enters the scene tree for the first time.
func _ready():
	if type == PointerType.LEVEL:
		$Level.show()
	if type == PointerType.SHOP:
		$Shop.show()
	var notifier = target_area.get_node('VisibleOnScreenNotifier2D') as VisibleOnScreenNotifier2D
	notifier.screen_entered.connect(func():
		var tween = get_tree().create_tween()
		tween.tween_property(self, 'modulate', Color(1, 1, 1, 0), 0.5)
	)
	notifier.screen_exited.connect(func():
		var tween = get_tree().create_tween()
		tween.tween_property(self, 'modulate', Color(1, 1, 1, 1), 0.5)
	)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotation = position.angle_to_point(target_area.position)
