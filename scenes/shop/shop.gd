extends Control

@onready var coin_count: Label = %CoinCount
@onready var preview_icon: Sprite2D = %PreviewIcon

var slots

func _ready() -> void:
	slots = get_tree().get_nodes_in_group("slot")
	for slot in slots:
		slot.slot_pressed.connect(change_icon)
	coin_count.text = str(PlayerStats.get_coins())

func change_icon(type_body, type_skin):
	if type_body == Skins.Type.HUMANS:
		preview_icon.texture = Skins.humans_atlas
	else :
		preview_icon.texture = Skins.animals_atlas
	var skin_rect = Skins.get_player_skin(type_body,type_skin)
	preview_icon.set_region_rect(skin_rect["rect"])
