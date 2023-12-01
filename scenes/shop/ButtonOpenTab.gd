extends Button

signal press_btn(ind)
@export var index_btn: int



func _on_pressed() -> void:
	emit_signal("press_btn", index_btn)
