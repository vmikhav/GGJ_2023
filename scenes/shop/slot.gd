extends Panel

signal slot_pressed(type_body, type_skin, slot_index)
signal bonus_slot_pressed(slot_index)
signal default_skin_bought

@onready var price_btn: Button = %PriceBtn
@onready var icon: Sprite2D = $Panel/Icon
@export var bonus_type: Bonuses.BonusType
@onready var open_skin: TextureRect = $PanelContainer/OpenSkin
@onready var close_skin: TextureRect = $PanelContainer/CloseSkin
@onready var price_text: Label = $PanelContainer/PriceText

var region
var type_body
var type_skin
var price: int
var bought: bool
var skin_arr
var must_unloced_skin
var slot_index

func _ready() -> void:
	if self.is_in_group("skins"):
		region = icon.region_rect
		skin_arr = find_skin_keys(region)
		must_unloced_skin = [type_body, 0]
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
		price_text.text = str(price)
		close_skin.visible = false
		open_skin.visible = false
		price_text.visible = true
	else:
		if bought == false:
			price = Skins.get_skin_price(type_body, type_skin)
			if PlayerStats.get_bought_skins().has(must_unloced_skin) or type_skin == 0:
				close_skin.visible = false
				price_text.visible = true
				open_skin.visible = false
			else :
				close_skin.visible = true
				open_skin.visible = false
				price_text.visible = false
		else:
			close_skin.visible = false
			open_skin.visible = true
			price_text.visible = false

func _on_button_pressed() -> void:
	if self.is_in_group("skins"):
		emit_signal("slot_pressed", type_body, type_skin, slot_index)
	else:
		emit_signal("bonus_slot_pressed", slot_index)
	update_price_text()

func _on_price_btn_pressed() -> void:
	var coins = PlayerStats.get_coins()
	if self.is_in_group("skins"):
		if bought == false:
			if PlayerStats.get_bought_skins().has(must_unloced_skin) or type_skin == 0:
				if coins >= price:
					bought = true
					PlayerStats.add_coins(-price)
					PlayerStats.set_bought_skins(type_body, type_skin)
					emit_signal("default_skin_bought")
				else: print("Not enough coins")
			else: print("must buy default skin")
		else :
			PlayerStats.set_current_skin(type_body, type_skin)
			print("current skin ", PlayerStats.get_current_skin())
	if self.is_in_group("bonuses"):
		if coins >= price:
			PlayerStats.add_bonus(bonus_type, 1)
			PlayerStats.add_coins(-price)
			update_price_text()
		else: print("Not enough coins")
