extends TextureButton

@onready var shop: Control = %Shop

func _on_pressed() -> void:
	PauseManager.game_paused = true
	shop.show()
	pass # Replace with function body.
