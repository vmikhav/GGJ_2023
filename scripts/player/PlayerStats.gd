extends Node

signal player_data_changed

var base_player_data = {
	"ship_respawn_pos": Vector2(285, 600),
	"coins": 0,
	"gems": 0,
	"bonuses": {"MILK": 0, "BOMB": 0, "CHANGE_RUNE": 0},
	"upgrades": {"health": 0, "guns": 0, "damage": 0, "speed": 0, "reload": 0},
	"level": 1,
	"skin": {"body_type": Skins.Type.FOX, "skin_type": Skins.SkinType.PIRATE},
	"bought_skins":[
		[Skins.Type.FOX, Skins.SkinType.DEFAULT],
		[Skins.Type.FOX, Skins.SkinType.PIRATE],
		[Skins.Type.HUMANS, Skins.SkinType.DEFAULT],
	],
	"tutorial_passed": 0,
}
var player_data = base_player_data

var button_ads_pressed = false
var time_bonus_milk = 5
var bomb_bonus_amount = 10
var change_symbol_amount = 10

func _ready() -> void:
	load_player_data()

func get_ship_respawn_pos() -> Vector2:
	return player_data["ship_respawn_pos"]

func set_ship_respawn_pos(pos: Vector2) -> void:
	player_data["ship_respawn_pos"] = pos
	save_player_data()

func get_coins() -> int:
	return player_data["coins"]
	
func add_coins(amount: int):
	player_data["coins"] += amount
	save_player_data()
	emit_signal("player_data_changed")

func get_gems() -> int:
	return player_data["gems"]
	
func add_gems(amount: int):
	player_data["gems"] += amount
	save_player_data()
	emit_signal("player_data_changed")
	
func get_bonuses(type_bonus: String) -> int:
	return player_data["bonuses"][type_bonus]
	
func add_bonus(bonus: Bonuses.BonusType, count: int):
	match bonus:
		Bonuses.BonusType.MILK:
			player_data["bonuses"]["MILK"] += count
		Bonuses.BonusType.BOMB:
			player_data["bonuses"]["BOMB"] += count
		Bonuses.BonusType.CHANGE_RUNE:
			player_data["bonuses"]["CHANGE_RUNE"] += count
	save_player_data()
	emit_signal("player_data_changed")
	
func get_upgrades() -> Dictionary:
	return player_data["upgrades"]
	
func add_upgrades(upgrade: String):
	player_data["upgrades"][upgrade] += 1
	save_player_data()
	emit_signal("player_data_changed")
	
func get_level() -> int:
	return player_data["level"]
	
func level_up():
	player_data["level"] += 1
	save_player_data()
	emit_signal("player_data_changed")

func get_current_skin() -> Dictionary:
	return player_data["skin"]
	
func set_current_skin(type, skin):
	player_data["skin"]["body_type"] = type
	player_data["skin"]["skin_type"] = skin
	save_player_data()
	emit_signal("player_data_changed")

func get_bought_skins() -> Array:
	return player_data["bought_skins"]
	
	
func set_bought_skins(type, skin):
	var new_skin = [type, skin]
	if !player_data["bought_skins"].has(new_skin):
		player_data["bought_skins"].append(new_skin)
		print("new skin buy ", new_skin)
		save_player_data()

func is_tutorial_passed() -> bool:
	return player_data["tutorial_passed"] == 1

func pass_tutorial():
	player_data["tutorial_passed"] = 1
	save_player_data()

func save_player_data():
	var config = ConfigFile.new()
	config.set_value("Ship", "respawn_pos", player_data["ship_respawn_pos"])
	config.set_value("Player", "coins", player_data["coins"])
	config.set_value("Player", "gems", player_data["gems"])
	config.set_value("Player", "bonuses", player_data["bonuses"])
	config.set_value("Player", "upgrades", player_data["upgrades"])
	config.set_value("Player", "level", player_data["level"])
	config.set_value("Player", "skin", player_data["skin"])
	config.set_value("Player", "bought_skins", player_data["bought_skins"])
	config.set_value("Player", "tutorial_passed", player_data["tutorial_passed"])
	config.save("user://player_data.cfg")
	
func load_player_data():
	var config = ConfigFile.new()
	if config.load("user://player_data.cfg") == OK:
		player_data["ship_respawn_pos"] = config.get_value("Ship", "respawn_pos", base_player_data["ship_respawn_pos"])
		player_data["coins"] = config.get_value("Player", "coins", base_player_data["coins"])
		player_data["gems"] = config.get_value("Player", "gems", base_player_data["gems"])
		player_data["bonuses"] = config.get_value("Player", "bonuses", base_player_data["bonuses"])
		player_data["upgrades"] = config.get_value("Player", "upgrades", base_player_data["upgrades"])
		player_data["level"] = config.get_value("Player", "level", base_player_data["level"])
		player_data["skin"] = config.get_value("Player", "skin", base_player_data["skin"])
		player_data["bought_skins"] = config.get_value("Player", "bought_skins", base_player_data["bought_skins"])
		player_data["tutorial_passed"] = config.get_value("Player", "tutorial_passed", base_player_data["tutorial_passed"])
