extends Panel

signal slot_pressed(type_body, type_skin)

@onready var price_btn: Button = $PriceBtn
@onready var icon: Sprite2D = $Panel/Icon
var region
var type_body
var type_skin
var price

func _ready() -> void:
	region = icon.region_rect
	find_skin_keys(region)
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
	price = Skins.get_skin_price(type_body, type_skin)
	var bought = Skins.get_skin_bought(type_body, type_skin)
	print( bought)
	if bought == false:
		price_btn.text = str(price)
	else:
		price_btn.text = "Use skin"

func _on_button_pressed() -> void:
	emit_signal("slot_pressed", type_body, type_skin)
	pass


func _on_price_btn_pressed() -> void:
	var coins = PlayerStats.get_coins()
	if coins >= price:
		PlayerStats.add_coins(-price)
		Skins.buy_skin(type_body, type_skin)
		print("buy skin")
		update_price_text() 
	else: print("Not enough coins")
