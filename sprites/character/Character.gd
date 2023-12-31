extends Node2D

var current_tile: Tile

var positionA: Vector2 = Vector2(0, 0)
var positionB: Vector2 = Vector2(0, 0)
var positionC: Vector2 = Vector2(0, 0)

var t: float = 0
var duration: float = 0.5
var dying = false
var died = false
var complete = false
var can_run = false
var last_save_tile = null
var last_save_duration = 0.5
var can_destroy_obstacle = false
var cur_skin

@onready var body: Sprite2D = $Sprite2D

signal win()
signal lose()
signal change_tile(tile: Tile)

# Called when the node enters the scene tree for the first time.
func _ready():
	PlayerStats.player_data_changed.connect(update_current_skin)
	update_current_skin()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if not can_run:
		return
	if died:
		position.y += 15
		position.x += 3 if positionB.x > positionA.x else -3
		return
	
	t += delta / duration
	var q0 = positionA.lerp(positionC, min(t, 1.0))
	var q1 = positionC.lerp(positionB, min(t, 1.0))
	position = q0.lerp(q1, min(t, 1.0))
	if t >= 1:
		if dying:
			died = true
			z_index = -1
		elif current_tile.next_tile.obstacle:
			if can_destroy_obstacle:
				destroy_obstacle()
			else :
				display_lose()
		elif current_tile.next_tile.next_tile:
			set_tile(current_tile.next_tile)
		else:
			display_win()

func reset(is_respawn: bool = false):
	can_run = true
	dying = false
	died = false
	complete = false
	z_index = 1
	if is_respawn:
		duration = last_save_duration
		can_destroy_obstacle = true
		await get_tree().create_timer(2).timeout
		can_destroy_obstacle = false
	else :
		duration = 0.5

func set_tile(tile: Tile) -> void:
	t = 0
	current_tile = tile
	change_tile.emit(current_tile)
	
	set_orientation(tile.orientation)
	position = current_tile.position
	
	positionA = current_tile.position
	positionB = current_tile.next_tile.position
	positionC = Vector2((positionB.x * 2 + positionA.x * 1) / 3, positionB.y - 70)

func set_orientation(orientation: Tile.ORIENTATION):
	var need_flip = orientation == Tile.ORIENTATION.LEFT_UP
	if need_flip != $Sprite2D.flip_h:
		$Sprite2D.position.x = -$Sprite2D.position.x
	$Sprite2D.flip_h = need_flip

func display_lose():
	restore_time()
	last_save_tile = current_tile
	last_save_duration = duration
	lose.emit()
	dying = true
	t = 0
	duration = 1
	var new_orientation = Tile.ORIENTATION.LEFT_UP if current_tile.orientation == Tile.ORIENTATION.RIGHT_UP else Tile.ORIENTATION.RIGHT_UP
	var jump_offset = Tile.OFFSET_LEFT_UP if new_orientation == Tile.ORIENTATION.LEFT_UP else Tile.OFFSET_RIGHT_UP
	set_orientation(new_orientation)
	positionA = current_tile.next_tile.position
	positionB = current_tile.next_tile.position + jump_offset * 2 + Vector2(0, 300)
	positionC = Vector2((positionB.x * 2 + positionA.x * 1) / 3, positionA.y - 160)

func display_win():
	if not complete:
		win.emit()
		complete = true
		duration = 0.5
	t = 0
	var new_orientation = Tile.ORIENTATION.LEFT_UP if not $Sprite2D.flip_h else Tile.ORIENTATION.RIGHT_UP
	set_orientation(new_orientation)
	positionA = current_tile.next_tile.position
	positionB = current_tile.next_tile.position
	positionC = Vector2(positionB.x, positionB.y - 70)

func destroy_obstacle():
	current_tile.next_tile.obstacle.remove()
	
func update_current_skin():
	cur_skin = PlayerStats.get_current_skin()
	change_character_skin(cur_skin["body_type"], cur_skin["skin_type"])

func change_character_skin(type, skin):
	body.texture = Skins.get_texture_atlas(type)
	var skin_rect = Skins.get_player_skin(type,skin)
	body.set_region_rect(skin_rect["rect"])
	body.position = skin_rect["position"]

func slow_time():
	last_save_duration = duration
	duration = 20

func restore_time():
	if duration > 10:
		duration = last_save_duration
