extends Node

class_name Skins

const COW = {
	"default": preload("res://sprites/character/assets/animals/Recurso 11.png"),
	"green": preload("res://sprites/character/assets/animals/Recurso 21.png")
}
const HORCE = {
	"default": preload("res://sprites/character/assets/animals/Recurso 10.png"),
	"green": preload("res://sprites/character/assets/animals/Recurso 20.png")
}
const CAT = {
	"default": preload("res://sprites/character/assets/animals/Recurso 15.png"),
	"green": preload("res://sprites/character/assets/animals/Recurso 25.png"),
	"pirate": preload("res://sprites/character/assets/animals/pirate_fox.png")
}  

static func get_player_skin(type: Dictionary, skin: String):
	var tex = type[skin]
	return tex
