extends Node2D

@onready var map = $TileMap
@onready var ship = $TileMap/Ship
@onready var pause_menu = %PauseMenu as PauseMenu
@onready var audio_stream_player: AudioStreamPlayer = %AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	$TouchCamera.target = ship
	map.click.connect(_on_click)
	var user_position = SceneSwitcher.get_param('respawn_position')
	if !user_position:
		user_position = PlayerStats.get_ship_respawn_pos()
	else:
		PlayerStats.set_ship_respawn_pos(user_position)
	ship.position = user_position
	$TouchCamera.position = ship.position	
		
	pause_menu.connect("pressed_exit_button", exit_from_pause)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_click(_position: Vector2):
	pass
	#ship.navigate(_position)

func exit_from_pause():
	PlayerStats.save_player_data()
	get_tree().quit()
