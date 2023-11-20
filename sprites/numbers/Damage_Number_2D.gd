class_name DamageNumber2D
extends Node2D

@onready var label:Label = %Label
@onready var label_container:Node2D = %LabelContainer
@onready var ap:AnimationPlayer = %AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

	
func set_values_and_animate(value:String, start_pos:Vector2, height:float, spread:float, color: Color) -> void:
	label.text = value
	label.label_settings.font_color = color
	#label.add_theme_color_override("font_color", color)
	ap.play("Rise and Fade")
	
	var tween = get_tree().create_tween()
	var end_pos = Vector2(randf_range(-spread,spread),-height) + start_pos
	var tween_length = ap.get_animation("Rise and Fade").length
	
	tween.tween_property(label_container,"position",end_pos,tween_length).from(start_pos)


func remove() -> void:
	ap.stop()
	if is_inside_tree():
		get_parent().remove_child(self)
		queue_free()
