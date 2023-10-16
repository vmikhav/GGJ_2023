extends Node

signal player_data_changed

var player_data = {
	"coins": 0,
	"bonuses": [],
	"upgrades": [],
	"level": 1
}


func get_coins() -> int:
	return player_data["coins"]
	
func add_coins(amount: int):
	player_data["coins"] += amount
	
func  get_bonuses() -> Array:
	return player_data["bonuses"]
	
func add_bonus(bonus: String):
	player_data["bonuses"].append(bonus)
	
func get_upgrades() -> Array:
	return player_data["upgrades"]
	
func add_upgrades(upgrade: String):
	player_data["upgrades"].append(upgrade)
	
func get_level() -> int:
	return player_data["level"]
	
func level_up():
	player_data["level"] += 1


func save_player_data():
	var config = ConfigFile.new()
	config.load("user://player_data.cfg")
	config.set_value("Player", "coins", player_data["coins"])
	config.set_value("Player", "bonuses", player_data["bonuses"])
	config.set_value("Player", "upgrades", player_data["upgrades"])
	config.set_value("Player", "level", player_data["level"])
	
func load_player_data():
	var config = ConfigFile.new()
	if config.load("user://player_data.cfg") == OK:
		player_data["coins"] = config.get_value("Player", "coins", 0)
		player_data["bonuses"] = config.get_value("Player", "bonuses", [])
		player_data["upgrades"] = config.get_value("Player", "upgrades", [])
		player_data["level"] = config.get_value("Player", "level", 1)
