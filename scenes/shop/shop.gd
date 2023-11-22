extends Control

@onready var coin_count: Label = %CoinCount
@onready var preview_icon: Sprite2D = %PreviewIcon

var slots

func _ready() -> void:
	PlayerStats.player_data_changed.connect(change_coin_count)
	slots = get_tree().get_nodes_in_group("slot")
	for slot in slots:
		if slot.is_in_group("skins"):
			slot.slot_pressed.connect(change_icon)
	change_coin_count()

func change_icon(type_body, type_skin):
	if type_body == Skins.Type.HUMANS:
		preview_icon.texture = Skins.humans_atlas
	else :
		preview_icon.texture = Skins.animals_atlas
	var skin_rect = Skins.get_player_skin(type_body,type_skin)
	preview_icon.set_region_rect(skin_rect["rect"])
	
func change_coin_count():
	coin_count.text = str(PlayerStats.get_coins())
	print("Coins = ", PlayerStats.get_coins())

func _on_button_return_pressed() -> void:
	hide()
	PauseManager.game_paused = false
