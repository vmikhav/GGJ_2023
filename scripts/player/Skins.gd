extends Node

class_name Skins

enum AnimalType{
	COW,
	HORCE,
	CAT
}
enum SkinType{
	DEFAULT,
	GREEN,
	PIRATE
}

const skins = {
	AnimalType.COW:{
		SkinType.DEFAULT: preload("res://sprites/character/assets/animals/Recurso 11.png"),
		SkinType.GREEN: preload("res://sprites/character/assets/animals/Recurso 21.png")
	},
	AnimalType.HORCE: {
		SkinType.DEFAULT: preload("res://sprites/character/assets/animals/Recurso 10.png"),
		SkinType.GREEN: preload("res://sprites/character/assets/animals/Recurso 20.png")
	},
	AnimalType.CAT: {
		SkinType.DEFAULT: preload("res://sprites/character/assets/animals/Recurso 15.png"),
		SkinType.GREEN: preload("res://sprites/character/assets/animals/Recurso 25.png"),
		SkinType.PIRATE: preload("res://sprites/character/assets/animals/pirate_fox.png")
	}
}

static func get_player_skin(type: int, skin: int):
	var tex = skins[type][skin]
	return tex
