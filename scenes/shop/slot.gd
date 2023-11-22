extends Panel

signal slot_pressed(type_body, type_skin)

@onready var price_btn: Button = $PriceBtn
@onready var icon: Sprite2D = $Panel/Icon
@export var bonus_type: Bonuses.BonusType
var region
var type_body
var type_skin
var price: int
var bought: bool

func _ready() -> void:
	if self.is_in_group("skins"):
		region = icon.region_rect
		var skin_arr = find_skin_keys(region)
		if PlayerStats.get_bought_skins().has(skin_arr):
			bought = true
	update_price_text()

func find_skin_keys(region_rect) -> Array:
	for type_key in Skins.skins.keys():
		var type_skins = Skins.skins[type_key]
		for skin_type_key in type_skins.keys():
			var skin_data = type_skins[skin_type_key]
			if skin_data["rect"] == region_rect:
				type_body = type_key
				type_skin = skin_type_key
				break
	return [type_body, type_skin]
	

func update_price_text():
	if self.is_in_group("bonuses"):
		price = Bonuses.get_price(bonus_type)
	else:
		if bought == false:
			price = Skins.get_skin_price(type_body, type_skin)
			price_btn.text = str(price)
		else:
			price_btn.text = "Use skin"

func _on_button_pressed() -> void:
	emit_signal("slot_pressed", type_body, type_skin)
	pass

func _on_price_btn_pressed() -> void:
	var coins = PlayerStats.get_coins()
	if self.is_in_group("skins"):
		emit_signal("slot_pressed", type_body, type_skin)
		if bought == false:
			if coins >= price:
				bought = true
				PlayerStats.add_coins(-price)
				PlayerStats.set_bought_skins(type_body, type_skin)
				print(PlayerStats.player_data["bought_skins"])
				update_price_text() 
			else: print("Not enough coins")
		else :
			PlayerStats.set_current_skin(type_body, type_skin)
			print(PlayerStats.get_current_skin())
	if self.is_in_group("bonuses"):
		if coins >= price:
			PlayerStats.add_bonus(bonus_type, 1)
			PlayerStats.add_coins(-price)
			update_price_text()
		else: print("Not enough coins")
	
