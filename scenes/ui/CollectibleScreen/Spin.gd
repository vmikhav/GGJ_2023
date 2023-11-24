extends TextureRect

@export var can_rotate = true
@export var speed = 10
@onready var skin_bonus: Sprite2D = $SkinBonus


var is_rotate = false
var is_revard = false
var angle 
var revard = section
var bonus_skin: Skins

enum section {
	Skines,
	Bomb,
	Milk,
	ChangeRune,
	Coin
}

func _ready() -> void:
	set_bonus_skin()

func _process(delta: float) -> void:
	if is_rotate == true:
		rotate_wheel()
		is_revard = false
		can_rotate = true
		
func rotate_wheel():
	var sp = speed
	$Arrow.rotation_degrees += sp
	await get_tree().create_timer(5).timeout
	sp = sp * 0.001
	is_rotate = false
	if is_revard == false:
		angle = fmod($Arrow.rotation_degrees, 360)
		print(angle)
	get_revard(angle)
	
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed() and can_rotate:
		is_rotate = true
		can_rotate = false

func get_revard(angle) -> int:
	if is_revard == false:
		if angle > 0 + 12 and angle <= 45 + 12:
			revard = section.Bomb
			print(revard)
		elif angle > 45 + 12 and angle <= 90 + 12:
			revard = section.Coin
			print(revard)
		elif angle > 90 + 12 and angle <= 135 + 12:
			revard = section.Skines
			print(revard)
			pass
		elif angle > 135 + 12 and angle <= 180 + 12:
			revard = section.Bomb
			print(revard)
		elif angle > 180 + 12 and angle <= 225 + 12:
			revard = section.Milk
			print(revard)
		elif angle > 225 + 12 and angle <= 270 + 12:
			revard = section.ChangeRune
			print(revard)
		elif angle > 270 + 12 and angle <= 315 + 12:
			revard = section.Coin
			print(revard)
		elif angle > 315 + 12 and angle <= 360 + 12:
			revard = section.Milk
			print(revard)
		is_revard = true
		add_bonus_to_data(revard)
	return revard

func add_bonus_to_data(revard):
	match revard:
		0:
			
			pass
		1:
			PlayerStats.add_bonus(Bonuses.BonusType.BOMB, 1)
		2:
			PlayerStats.add_bonus(Bonuses.BonusType.MILK, 1)
		3:
			PlayerStats.add_bonus(Bonuses.BonusType.CHANGE_RUNE, 1)
		4:
			PlayerStats.add_coins(10)

func set_bonus_skin():
	var type = randi_range(0, Skins.Type.size())
	var type_skin = randi_range(0, Skins.skins[type].size())
	print(type, "type atlas")
	print(type_skin)
	if type == Skins.Type.HUMANS:
		skin_bonus.texture = Skins.humans_atlas
		print("humen")
	else :
		skin_bonus.texture = Skins.animals_atlas
		print("enimal")
	var skin_rect = Skins.get_player_skin(type,type_skin)
	skin_bonus.set_region_rect(skin_rect["rect"])
