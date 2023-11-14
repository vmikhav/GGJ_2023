extends Panel

signal slot_pressed(type_body, type_skin)

@onready var price_btn: Button = $PriceBtn
@onready var icon: Sprite2D = $Panel/Icon
var region

func _ready() -> void:
	region = icon.region_rect

func find_skin_keys(region_rect):
	var type_body
	var type_skin
	for type_key in Skins.skins.keys():
		var type_skins = Skins.skins[type_key]
		
		for skin_type_key in type_skins.keys():
			var skin_data = type_skins[skin_type_key]
			if skin_data["rect"] == region_rect:
				type_body = type_key
				type_skin = skin_type_key
				break
	emit_signal("slot_pressed", type_body, type_skin)

func _on_button_pressed() -> void:
	find_skin_keys(region)
	#print(new_skin)
	pass


func _on_price_btn_pressed() -> void:
	pass # Replace with function body.
