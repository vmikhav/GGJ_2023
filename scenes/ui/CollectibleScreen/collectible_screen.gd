extends Control

@onready var reward_container: VBoxContainer = $PanelFound/VBoxContainer
@onready var spin: TextureRect = $PanelFound/Spin
@onready var animation_screen: AnimationPlayer = $AnimationScreen

func _ready() -> void:
	animation_screen.play("collectible_screen_anim")
	reward_container.hide()
	spin.show()
	spin.show_bonus_screen.connect(show_screen)
	
func show_screen():
	spin.hide()
	reward_container.show()

func _on_button_close_pressed() -> void:
	hide()
