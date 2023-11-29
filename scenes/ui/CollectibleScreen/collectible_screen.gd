extends Control

@onready var v_box_container: VBoxContainer = $PanelFound/VBoxContainer
@onready var spin: TextureRect = $PanelFound/Spin
@onready var animation_screen: AnimationPlayer = $AnimationScreen

func _ready() -> void:
	animation_screen.play("collectible_screen_anim")
	v_box_container.hide()
	spin.show()
	spin.connect("show_bonus_screen", show_screen)
	
func show_screen():
	spin.hide()
	v_box_container.show()

func _on_button_close_pressed() -> void:
	hide()
