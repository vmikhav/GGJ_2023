extends TextureRect

signal show_bonus_screen

@export var can_rotate = true
@export var speed = 700
@onready var skin_bonus: Sprite2D = $SkinBonus
@onready var bonus_icon: Sprite2D = $"../VBoxContainer/MarginContainer/BonusIcon"
@onready var button_double: Button = $"../VBoxContainer/ButtonDouble"
@onready var label_count: Label = $"../VBoxContainer/MarginContainer/LabelCount"
@onready var animation_tap_to_spin: AnimationPlayer = $"../../AnimationTapToSpin"
@onready var margin_container: MarginContainer = $MarginContainer



var bomb_icon = load("res://themes/forest/assets/game boost2.png")
var milk_icon = load("res://themes/forest/assets/game boost3.png")
var change_rune_icon = load("res://themes/forest/assets/game boost1.png")
var coin1_icon = load("res://themes/forest/assets/shop coin1.png")
var coin2_icon = load("res://themes/forest/assets/shop coin3.png")
var is_rotate = false
var is_revard = false
var angle_arrow
var revard = section
var bonus_skin
var type
var type_skin
var coin_count = 20
var skin_for_spin: Array
var available_skins: Array = []
var bought_skins = PlayerStats.get_bought_skins()

enum section {
	Skines,
	Bomb,
	Milk,
	ChangeRune,
	Coin,
	Coin2
}

func _ready() -> void:
	animation_tap_to_spin.play("tap_to_spin_anim")
	set_random_bonus_skin()

func _process(delta: float) -> void:
	if is_rotate == true:
		rotate_wheel(delta)
		is_revard = false
		can_rotate = true
		
func rotate_wheel(delta):
	var sp = speed
	$Arrow.rotation_degrees += sp * delta
	await get_tree().create_timer(5).timeout
	sp = sp * 0.001
	is_rotate = false
	if is_revard == false:
		angle_arrow = fmod($Arrow.rotation_degrees, 360)
	get_revard(angle_arrow)
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed() and can_rotate:
		is_rotate = true
		can_rotate = false
		animation_tap_to_spin.stop()
		margin_container.hide()

func get_revard(angle) -> int:
	if is_revard == false:
		if angle > 0 + 12 and angle <= 45 + 12:
			revard = section.Bomb
		elif angle > 45 + 12 and angle <= 90 + 12:
			revard = section.Coin
		elif angle > 90 + 12 and angle <= 135 + 12:
			revard = section.Skines
			pass
		elif angle > 135 + 12 and angle <= 180 + 12:
			revard = section.Bomb
		elif angle > 180 + 12 and angle <= 225 + 12:
			revard = section.Milk
		elif angle > 225 + 12 and angle <= 270 + 12:
			revard = section.ChangeRune
		elif angle > 270 + 12 and angle <= 315 + 12:
			revard = section.Coin2
		elif angle > 315 + 12 and angle <= 360 + 12:
			revard = section.Milk
		is_revard = true
		add_bonus_to_data(revard)
	return revard

func add_bonus_to_data(_revard):
	match _revard:
		0:
			add_bonus_skin_icon(type, type_skin)
			button_double.visible = false
			label_count.visible = false
			PlayerStats.set_bought_skins(type, type_skin)
			pass
		1:
			add_bonus_icon(bomb_icon)
			button_double.visible = false
			label_count.visible = false
			PlayerStats.add_bonus(Bonuses.BonusType.BOMB, 1)
		2:
			add_bonus_icon(milk_icon)
			button_double.visible = false
			label_count.visible = false
			PlayerStats.add_bonus(Bonuses.BonusType.MILK, 1)
		3:
			add_bonus_icon(change_rune_icon)
			button_double.visible = false
			label_count.visible = false
			PlayerStats.add_bonus(Bonuses.BonusType.CHANGE_RUNE, 1)
		4:
			add_bonus_icon(coin1_icon)
			button_double.visible = true
			label_count.visible = true
			label_count.text = "*" + str(coin_count)
			PlayerStats.add_coins(coin_count)
		5: 
			add_bonus_icon(coin2_icon)
			button_double.visible = true
			label_count.visible = true
			label_count.text = "*" + str(coin_count)
			PlayerStats.add_coins(coin_count)
	await get_tree().create_timer(3.0).timeout
	show_bonus_screen.emit()

func set_random_bonus_skin():
	var rand_skin = get_skin_for_spin().pick_random()
	type = rand_skin[0]
	type_skin = rand_skin[1]
	skin_bonus.texture = Skins.get_texture_atlas(type)
	var skin_rect = Skins.get_player_skin(type,type_skin)
	skin_bonus.set_region_rect(skin_rect["rect"])
	

func add_bonus_skin_icon(type_body, skin):
	bonus_icon.region_enabled = true
	bonus_icon.texture = Skins.get_texture_atlas(type_body)
	bonus_skin = Skins.get_player_skin(type_body, skin)
	bonus_icon.set_region_rect(bonus_skin["rect"])

func add_bonus_icon(icon):
	bonus_icon.region_enabled = false
	bonus_icon.texture = icon

func get_skin_for_spin() -> Array:
	
	for t in Skins.skins:
		for skin in Skins.skins[t]:
			if bought_skins.has([t, 0]):
				available_skins.append([t, skin])
	for skin in available_skins:
		if !bought_skins.has(skin):
			skin_for_spin.append(skin)
	return skin_for_spin
