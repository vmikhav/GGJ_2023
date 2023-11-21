extends Node

signal player_data_changed

var player_data = {
	"coins": 1000,
	"bonuses": {"MILK": 5, "BOMB": 0, "CHANGE_RUNE": 0},
	"upgrades": [],
	"level": 1,
	"skin": {"body_type": 0, "skin_type": 0},
	"bought_skins":[[0, 0]]
}

var button_ads_pressed = false
var time_bonus_milk = 5
var bomb_bonus_amount = 10
var change_symbol_amount = 10

func _ready() -> void:
	load_player_data()

func get_coins() -> int:
	return player_data["coins"]
	
func add_coins(amount: int):
	player_data["coins"] += amount
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
	print(player_data.bonuses)
	emit_signal("player_data_changed")
	
func get_upgrades() -> Array:
	return player_data["upgrades"]
	
func add_upgrades(upgrade: String):
	player_data["upgrades"].append(upgrade)
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
		print( new_skin)
		save_player_data()
	
func save_player_data():
	var config = ConfigFile.new()
	config.load("user://player_data.cfg")
	config.set_value("Player", "coins", player_data["coins"])
	config.set_value("Player", "bonuses", player_data["bonuses"])
	config.set_value("Player", "upgrades", player_data["upgrades"])
	config.set_value("Player", "level", player_data["level"])
	config.set_value("Player", "skin", player_data["skin"])
	config.set_value("Player", "bought_skins", player_data["bought_skins"])
	config.save("user://player_data.cfg")
	
func load_player_data():
	var config = ConfigFile.new()
	if config.load("user://player_data.cfg") == OK:
		player_data["coins"] = config.get_value("Player", "coins", 0)
		player_data["bonuses"] = config.get_value("Player", "bonuses", {})
		player_data["upgrades"] = config.get_value("Player", "upgrades", [])
		player_data["level"] = config.get_value("Player", "level", 1)
		player_data["skin"] = config.get_value("Player", "skin",{})
		player_data["bought_skins"] = config.get_value("Player", "bought_skins", [] as Array)
