extends Area2D

@export var respawn_position: Vector2
signal enter_shop

# Called when the node enters the scene tree for the first time.
func _ready():
	body_entered.connect(_start_level)


func _start_level(_body):
	_body.get_class()
	
	if _body.is_class("CharacterBody2D") and _body.body_type == 'ship' and _body.controlled:
		if not _body.see_enemies():
			_body.position = position + respawn_position
			enter_shop.emit()
