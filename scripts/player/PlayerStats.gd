extends Node

signal player_data_changed

var player_data = {
	"ship_respawn_pos": Vector2(285, 600),
	"coins": 0,
	"bonuses": [],
	"upgrades": [],
	"level": 1,
	"skin": {"body_type": 0, "skin_type": 0},
	"bought_skins":[[0, 0], [0, 1],[0, 2]]
}

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
	
func get_bonuses() -> Array:
	return player_data["bonuses"]
	
func add_bonus(bonus: String):
	player_data["bonuses"].append(bonus)
	save_player_data()
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
	config.set_value("Ship", "respawn_pos", player_data["ship_respawn_pos"])
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
		player_data["ship_respawn_pos"] = config.get_value("Ship", "respawn_pos", Vector2(285, 600))
		player_data["coins"] = config.get_value("Player", "coins", 0)
		player_data["bonuses"] = config.get_value("Player", "bonuses", [])
		player_data["upgrades"] = config.get_value("Player", "upgrades", [])
		player_data["level"] = config.get_value("Player", "level", 1)
		player_data["skin"] = config.get_value("Player", "skin",{})
		player_data["bought_skins"] = config.get_value("Player", "bought_skins", [] as Array)
