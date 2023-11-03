extends TextureButton

signal change_symbol

@onready var count: Label = $Count

var has_bonus: bool = false


func  _ready() -> void:
	update_visibility()

func _on_pressed() -> void:
	if has_bonus:
		emit_signal("change_symbol")

func update_visibility():
	if has_bonus:
		modulate = Color(1,1,1,1)
	else:
		modulate = Color(1,1,1,0.5)
