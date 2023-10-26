extends TextureButton

@onready var count: Label = $Count

var has_bonus: bool = false


func  _ready() -> void:
	update_visibility()

func _on_pressed() -> void:
	pass # Replace with function body.

func update_visibility():
	if has_bonus:
		modulate = Color(1,1,1,1)
	else:
		modulate = Color(1,1,1,0.5)
