extends Node2D

@onready var map = $TileMap
@onready var ship = $TileMap/Ship

# Called when the node enters the scene tree for the first time.
func _ready():
	$TouchCamera.position = ship.position
	$TouchCamera.target = ship
	map.click.connect(_on_click)
	var user_position = SceneSwitcher.get_param('respawn_position')
	if user_position != null:
		ship.position = user_position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_click(_position: Vector2):
	ship.navigate(_position)

