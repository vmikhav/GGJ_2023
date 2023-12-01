extends Control

@onready var coin_count: Label = %CoinCount
@onready var preview_icon: Sprite2D = %PreviewIcon
@onready var tab_container: TabContainer = $Panel/TabContainer
@onready var button_container: HBoxContainer = $Panel/TabContainer/Skins/VBoxContainer/DefaultSkins/ScrolContainer/ButtonContainer
@onready var tab_container_skins: TabContainer = $Panel/TabContainer/Skins/VBoxContainer/TabContainer

var slots

func _ready() -> void:
	for btn in button_container.get_children():
		btn.press_btn.connect(change_tab)
	
	PlayerStats.player_data_changed.connect(change_coin_count)
	slots = get_tree().get_nodes_in_group("slot")
	for slot in slots:
		if slot.is_in_group("skins"):
			slot.slot_pressed.connect(change_icon)
	change_coin_count()

func change_icon(type_body, type_skin):
	preview_icon.texture = Skins.get_texture_atlas(type_body)
	var skin_rect = Skins.get_player_skin(type_body,type_skin)
	preview_icon.set_region_rect(skin_rect["rect"])
	
func change_coin_count():
	coin_count.text = str(PlayerStats.get_coins())
	print("Coins = ", PlayerStats.get_coins())

func _on_button_return_pressed() -> void:
	hide()
	PauseManager.game_paused = false


func _on_button_skins_pressed() -> void:
	tab_container.current_tab = 1


func _on_button_bonuses_pressed() -> void:
	tab_container.current_tab = 2

func change_tab(inx):
	tab_container_skins.current_tab = inx
