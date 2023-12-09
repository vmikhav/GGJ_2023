extends Node2D

@onready var map = $TileMap
@onready var ship = $TileMap/Ship
@onready var pause_menu = %PauseMenu as PauseMenu
@onready var audio_stream_player: AudioStreamPlayer = %AudioStreamPlayer
@onready var shop: Control = %Shop

# Called when the node enters the scene tree for the first time.
func _ready():
	Respawner.set_scene(self)
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
	var _shops = get_tree().get_nodes_in_group("shop_selector")
	for _shop in _shops:
		_shop.enter_shop.connect(func():
			PauseManager.game_paused = true
			shop.show()
		)
	var _levels = get_tree().get_nodes_in_group("level_selector")
	var _current_level = randi_range(0, _levels.size() - 1)
	for i in _levels.size():
		if i != _current_level:
			_levels[i].queue_free()
	_levels[_current_level].show()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_click(_position: Vector2):
	pass
	#ship.navigate(_position)

func exit_from_pause():
	PlayerStats.save_player_data()
	get_tree().quit()
