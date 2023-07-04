extends Node2D

@onready var map = $TileMap
@onready var ship = $TileMap/Ship
@onready var area = $TileMap/Area2D as Area2D

# Called when the node enters the scene tree for the first time.
func _ready():
	map.click.connect(_on_click)
	area.body_entered.connect(_start_level)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_click(_position: Vector2):
	ship.navigate(_position)

func _start_level(_body):
	if _body.is_class("CharacterBody2D") and _body.controlled:
		SceneSwitcher.change_scene_to_file('res://scenes/level/Level.tscn', {'theme': TileProvider.TileTheme.NIGHT_FOREST})
