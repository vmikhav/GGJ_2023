extends Control

@onready var coin_count: Label = %CoinCount
@onready var preview_icon: Sprite2D = %PreviewIcon
@onready var tab_container: TabContainer = $Panel/TabContainer
@onready var button_container: HBoxContainer = $Panel/TabContainer/Skins/VBoxContainer/DefaultSkins/ScrolContainer/ButtonContainer
@onready var tab_container_skins: TabContainer = $Panel/TabContainer/Skins/VBoxContainer/TabContainer
@onready var price_btn: Button = %PriceBtn
@onready var preview: VBoxContainer = $Preview
@onready var bonus_preview: Sprite2D = $Preview/Container/BonusPreview

var slots: Array
var current_slot

func _ready() -> void:
	preview.visible = false
	price_btn.visible = false
	price_btn.pressed.connect(buy_skin_from_slot)
	for btn in button_container.get_children():
		btn.press_btn.connect(change_tab)
	
	PlayerStats.player_data_changed.connect(change_coin_count)
	slots = get_tree().get_nodes_in_group("slot")
	for i in slots.size():
		var slot = slots[i]
		slot.slot_index = i
		if slot.is_in_group("skins"):
			slot.slot_pressed.connect(change_icon)
			slot.default_skin_bought.connect(update_slots)
		else:
			slot.bonus_slot_pressed.connect(change_bonus_icon)
	change_coin_count()

func change_icon(type_body, type_skin, slot_index):
	preview_icon.texture = Skins.get_texture_atlas(type_body)
	var skin_rect = Skins.get_player_skin(type_body,type_skin)
	preview_icon.set_region_rect(skin_rect["rect"])
	current_slot = slots[slot_index]
	price_btn.visible = true
	update_price_btn(current_slot)
	
func change_bonus_icon(slot_index):
	current_slot = slots[slot_index]
	bonus_preview.texture = current_slot.icon.texture
	price_btn.visible = true
	update_price_btn(current_slot)
	
func change_coin_count():
	coin_count.text = str(PlayerStats.get_coins())

func _on_button_return_pressed() -> void:
	hide()
	PauseManager.game_paused = false

func _on_button_skins_pressed() -> void:
	preview.visible = true
	tab_container.current_tab = 1
	preview_icon.visible = true
	bonus_preview.visible = false

func _on_button_bonuses_pressed() -> void:
	preview.visible = true
	tab_container.current_tab = 2
	preview_icon.visible = false
	bonus_preview.visible = true

func change_tab(inx):
	tab_container_skins.current_tab = inx

func buy_skin_from_slot():
	if current_slot:
		current_slot._on_price_btn_pressed()
		update_price_btn(current_slot)

func update_slots():
	for slot in slots:
		slot.update_price_text()

func update_price_btn(cur_slot):
	var pr = cur_slot.price
	if cur_slot.bought == true:
		price_btn.text = "Use skin"
	else:
		price_btn.text = str(pr)
