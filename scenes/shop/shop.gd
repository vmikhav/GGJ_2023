extends Control

@onready var coin_count: Label = %CoinCount
@onready var gem_count: Label = %GemCount
@onready var preview_icon: Sprite2D = %PreviewIcon
@onready var tab_container: TabContainer = $Panel/TabContainer
@onready var button_container: HBoxContainer = $Panel/TabContainer/Skins/VBoxContainer/DefaultSkins/ScrolContainer/ButtonContainer
@onready var tab_container_skins: TabContainer = $Panel/TabContainer/Skins/VBoxContainer/TabContainer
@onready var price_btn: Button = %PriceBtn
@onready var preview: VBoxContainer = $Preview
@onready var bonus_preview: Sprite2D = $Preview/Container/BonusPreview
@onready var upgrade_preview: Sprite2D = $Preview/Container/UpgradePreview

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
	prepare_upgrade_store(true)

func change_icon(type_body: Skins.Type, type_skin: Skins.SkinType, slot_index: int):
	var _current_skin = PlayerStats.get_current_skin()
	if type_body == _current_skin['body_type'] and type_skin == _current_skin['skin_type']:
		price_btn.visible = false
		slot_index = -1
	preview_icon.texture = Skins.get_texture_atlas(type_body)
	var skin_rect = Skins.get_player_skin(type_body,type_skin)
	preview_icon.set_region_rect(skin_rect["rect"])
	if slot_index >= 0:
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
	gem_count.text = str(PlayerStats.get_gems())

func prepare_upgrade_store(callbacks: bool = false):
	var _upgrades = PlayerStats.get_upgrades()
	%Health/Label.text = 'Health: Level ' + str(_upgrades['health'] + 1)
	%Guns/Label.text = 'Cannons: Level ' + str(_upgrades['guns'] + 1)
	%Damage/Label.text = 'Damage: Level ' + str(_upgrades['damage'] + 1)
	%Speed/Label.text = 'Speed: Level ' + str(_upgrades['speed'] + 1)
	%Reload/Label.text = 'Reload: Level ' + str(_upgrades['reload'] + 1)
	if _upgrades['health'] >= 3:
		%Health/Button.visible = false
	else:
		%Health/Button.visible = true
		%Health/Button.text = str(Skins.upgrades["health"][_upgrades['health'] + 1].price)
		if callbacks:
			%Health/Button.pressed.connect(func ():
				if PlayerStats.get_gems() > Skins.upgrades["health"][PlayerStats.get_upgrades()['health'] + 1].price:
					PlayerStats.add_gems(-Skins.upgrades["health"][PlayerStats.get_upgrades()['health'] + 1].price)
					PlayerStats.add_upgrades("health")
					prepare_upgrade_store()
			)
	if _upgrades['guns'] >= 3:
		%Guns/Button.visible = false
	else:
		%Guns/Button.visible = true
		%Guns/Button.text = str(Skins.upgrades["guns"][_upgrades['guns'] + 1].price)
		if callbacks:
			%Guns/Button.pressed.connect(func ():
				if PlayerStats.get_gems() > Skins.upgrades["guns"][PlayerStats.get_upgrades()['guns'] + 1].price:
					PlayerStats.add_gems(-Skins.upgrades["guns"][PlayerStats.get_upgrades()['guns'] + 1].price)
					PlayerStats.add_upgrades("guns")
					prepare_upgrade_store()
			)
	if _upgrades['damage'] >= 3:
		%Damage/Button.visible = false
	else:
		%Damage/Button.visible = true
		%Damage/Button.text = str(Skins.upgrades["damage"][_upgrades['damage'] + 1].price)
		if callbacks:
			%Damage/Button.pressed.connect(func ():
				if PlayerStats.get_gems() > Skins.upgrades["damage"][PlayerStats.get_upgrades()['damage'] + 1].price:
					PlayerStats.add_gems(-Skins.upgrades["damage"][PlayerStats.get_upgrades()['damage'] + 1].price)
					PlayerStats.add_upgrades("damage")
					prepare_upgrade_store()
			)
	if _upgrades['speed'] >= 3:
		%Speed/Button.visible = false
	else:
		%Speed/Button.visible = true
		%Speed/Button.text = str(Skins.upgrades["speed"][_upgrades['speed'] + 1].price)
		if callbacks:
			%Speed/Button.pressed.connect(func ():
				if PlayerStats.get_gems() > Skins.upgrades["speed"][PlayerStats.get_upgrades()['speed'] + 1].price:
					PlayerStats.add_gems(-Skins.upgrades["speed"][PlayerStats.get_upgrades()['speed'] + 1].price)
					PlayerStats.add_upgrades("speed")
					prepare_upgrade_store()
			)
	if _upgrades['reload'] >= 3:
		%Reload/Button.visible = false
	else:
		%Reload/Button.visible = true
		%Reload/Button.text = str(Skins.upgrades["reload"][_upgrades['reload'] + 1].price)
		if callbacks:
			%Reload/Button.pressed.connect(func ():
				if PlayerStats.get_gems() > Skins.upgrades["reload"][PlayerStats.get_upgrades()['reload'] + 1].price:
					PlayerStats.add_gems(-Skins.upgrades["reload"][PlayerStats.get_upgrades()['reload'] + 1].price)
					PlayerStats.add_upgrades("reload")
					prepare_upgrade_store()
			)

func _on_button_return_pressed() -> void:
	hide()
	PauseManager.game_paused = false

func _on_button_skins_pressed() -> void:
	var _current_skin = PlayerStats.get_current_skin()
	change_icon(_current_skin['body_type'], _current_skin['skin_type'], -1)
	change_tab(_current_skin['body_type'])
	preview.visible = true
	tab_container.current_tab = 1
	preview_icon.visible = true
	bonus_preview.visible = false
	upgrade_preview.visible = false

func _on_button_bonuses_pressed() -> void:
	preview.visible = true
	tab_container.current_tab = 2
	preview_icon.visible = false
	bonus_preview.visible = true
	upgrade_preview.visible = false

func _on_button_upgrades_pressed() -> void:
	preview.visible = true
	tab_container.current_tab = 3
	preview_icon.visible = false
	bonus_preview.visible = false
	upgrade_preview.visible = true

func change_tab(inx):
	tab_container_skins.current_tab = inx

func buy_skin_from_slot():
	if current_slot:
		current_slot._on_price_btn_pressed()
		update_price_btn(current_slot)
		price_btn.visible = false

func update_slots():
	for slot in slots:
		slot.update_price_text()

func update_price_btn(cur_slot):
	var pr = cur_slot.price
	if cur_slot.bought == true:
		price_btn.text = "Use skin"
	else:
		price_btn.text = str(pr)

func _on_buton_home_tab_pressed() -> void:
	tab_container.current_tab = 0
	preview.visible = false
	price_btn.visible = false
