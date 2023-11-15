extends Node


var humans_atlas = load("res://sprites/character/assets/humans/humans.png")
var animals_atlas = load("res://sprites/character/assets/animals/anmls 2.png")

enum Type{
	HORCE,
	COW,
	RACCOON,
	BEAVER,
	HAMSTER,
	CAT,
	RABBIT,
	DEER,
	LION,
	HUMANS
}
enum SkinType{
	DEFAULT,
	SCOUT,
	CROCODILE,
	WAITER,
	SPEARMEN,
	MAGICIAN,
	PIRATE,
	SHERIFF,
	FARMER,
	COFFEE,
	HALLOWEEN,
	CATMAN,
	POTATO,
	HAMBURGER,
	KNIGHT,
	ADVENTURER,
	ARCHER
}

var skins = {
	Type.HORCE: {
		SkinType.DEFAULT: {"rect":Rect2(23, 51, 107, 125),"position": Vector2(-5, -63), "price": 0, "bought": true},
		SkinType.SCOUT: {"rect": Rect2(24, 219, 107, 141), "position": Vector2(-6, -71), "price": 100, "bought": false},
		SkinType.CROCODILE: {"rect": Rect2(26, 402, 107, 138), "position": Vector2(-6, -71), "price": 100, "bought": false},
		SkinType.WAITER: {"rect": Rect2(25, 595, 130, 125), "position": Vector2(5, -63), "price": 100, "bought": false},
		SkinType.SPEARMEN: {"rect": Rect2(18, 772, 144, 133), "position": Vector2(-6, -71), "price": 100, "bought": false},
		SkinType.MAGICIAN: {"rect": Rect2(21, 925, 131, 155), "position": Vector2(5, -78), "price": 100, "bought": false},
		SkinType.PIRATE: {"rect": Rect2(18, 1116, 116, 146), "position": Vector2(0, -73), "price": 100, "bought": false},
		SkinType.SHERIFF: {"rect": Rect2(20, 1316, 117, 127), "position": Vector2(0, -64), "price": 100, "bought": false},
		SkinType.COFFEE: {"rect": Rect2(20, 1484, 121, 136), "position": Vector2(0, -68), "price": 100, "bought": false},
	},
	Type.COW:{
		SkinType.DEFAULT: {"rect": Rect2(214, 52, 113, 125), "position": Vector2(0, -63), "price": 100, "bought": false},
		SkinType.SCOUT: {"rect": Rect2(214, 217, 113, 139), "position": Vector2(0, -70), "price": 100, "bought": false},
		SkinType.CROCODILE: {"rect": Rect2(213, 399, 113, 139), "position": Vector2(0, -70), "price": 100, "bought": false},
		SkinType.WAITER: {"rect": Rect2(202, 595, 129, 125), "position": Vector2(4, -63), "price": 100, "bought": false},
		SkinType.SPEARMEN: {"rect": Rect2(203, 771, 129, 133), "position": Vector2(0, -67), "price": 100, "bought": false},
		SkinType.MAGICIAN: {"rect": Rect2(206, 925, 132, 156), "position": Vector2(0, -78), "price": 100, "bought": false},
		SkinType.PIRATE: {"rect": Rect2(205, 1117, 114, 145), "position": Vector2(0, -73), "price": 100, "bought": false},
		SkinType.SHERIFF: {"rect": Rect2(212, 1312, 116, 129), "position": Vector2(0, -65), "price": 100, "bought": false},
		SkinType.COFFEE: {"rect": Rect2(204, 1488, 121, 135), "position": Vector2(0, -68), "price": 100, "bought": false},
	},
	Type.RACCOON: {
		SkinType.DEFAULT: {"rect": Rect2(393, 53, 115, 125), "position": Vector2(0, -62), "price": 100, "bought": false},
		SkinType.SCOUT: {"rect": Rect2(391, 220, 115, 137), "position": Vector2(0, -69), "price": 100, "bought": false},
		SkinType.CROCODILE: {"rect": Rect2(389, 402, 115, 136), "position": Vector2(0, -68), "price": 100, "bought": false},
		SkinType.WAITER: {"rect": Rect2(378, 595, 153, 126), "position": Vector2(0, -63), "price": 100, "bought": false},
		SkinType.SPEARMEN: {"rect": Rect2(388, 771, 149, 134), "position": Vector2(0, -68), "price": 100, "bought": false},
		SkinType.MAGICIAN: {"rect": Rect2(382, 928, 151, 155), "position": Vector2(0, -78), "price": 100, "bought": false},
		SkinType.PIRATE: {"rect": Rect2(388, 1116, 121, 144), "position": Vector2(0, -72), "price": 100, "bought": false},
		SkinType.SHERIFF: {"rect": Rect2(389, 1310, 122, 130), "position": Vector2(0, -65), "price": 100, "bought": false},
		SkinType.COFFEE: {"rect": Rect2(389, 1487, 144, 133), "position": Vector2(0, -66), "price": 100, "bought": false},
	},
	Type.BEAVER:{
		SkinType.DEFAULT: {"rect": Rect2(576, 59, 116, 116), "position": Vector2(0, -58), "price": 100, "bought": false},
		SkinType.SCOUT: {"rect": Rect2(573, 219, 117, 137), "position": Vector2(0, -68), "price": 100, "bought": false},
		SkinType.CROCODILE: {"rect": Rect2(571, 400, 116, 137), "position": Vector2(0, -68), "price": 100, "bought": false},
		SkinType.WAITER: {"rect": Rect2(571, 604, 153, 116), "position": Vector2(0, -58), "price": 100, "bought": false},
		SkinType.SPEARMEN: {"rect": Rect2(569, 770, 137, 133), "position": Vector2(0, -66), "price": 100, "bought": false},
		SkinType.MAGICIAN: {"rect": Rect2(571, 927, 151, 155), "position": Vector2(0, -78), "price": 100, "bought": false},
		SkinType.PIRATE: {"rect": Rect2(559, 1114, 121, 146), "position": Vector2(0, -73), "price": 100, "bought": false},
		SkinType.SHERIFF: {"rect": Rect2(579, 1309, 122, 132), "position": Vector2(0, -66), "price": 100, "bought": false},
		SkinType.COFFEE: {"rect": Rect2(571, 1482, 144, 138), "position": Vector2(0, -69), "price": 100, "bought": false},
	},
	Type.HAMSTER:{
		SkinType.DEFAULT: {"rect": Rect2(768, 59, 108, 116), "position": Vector2(0, -58), "price": 100, "bought": false},
		SkinType.SCOUT: {"rect": Rect2(770, 218, 108, 138), "position": Vector2(0, -69), "price": 100, "bought": false},
		SkinType.CROCODILE: {"rect": Rect2(768, 401, 108, 137), "position": Vector2(0, -69), "price": 100, "bought": false},
		SkinType.WAITER: {"rect": Rect2(762, 603, 146, 117), "position": Vector2(0, -59), "price": 100, "bought": false},
		SkinType.SPEARMEN: {"rect": Rect2(769, 770, 143, 133), "position": Vector2(0, -67), "price": 100, "bought": false},
		SkinType.MAGICIAN: {"rect": Rect2(764, 929, 142, 154), "position": Vector2(0, -77), "price": 100, "bought": false},
		SkinType.PIRATE: {"rect": Rect2(766, 1126, 113, 145), "position": Vector2(0, -73), "price": 100, "bought": false},
		SkinType.SHERIFF: {"rect": Rect2(770, 1308, 114, 134), "position": Vector2(0, -67), "price": 100, "bought": false},
		SkinType.COFFEE: {"rect": Rect2(765, 1484, 138, 136), "position": Vector2(0, -67), "price": 100, "bought": false},
	},
	Type.CAT:{
		SkinType.DEFAULT: {"rect": Rect2(952, 51, 112, 123), "position": Vector2(0, -62), "price": 100, "bought": false},
		SkinType.SCOUT: {"rect": Rect2(958, 223, 113, 132), "position": Vector2(0, -66), "price": 100, "bought": false},
		SkinType.CROCODILE: {"rect": Rect2(962, 406, 111, 132), "position": Vector2(0, -66), "price": 100, "bought": false},
		SkinType.WAITER: {"rect": Rect2(964, 596, 148, 124), "position": Vector2(0, -62), "price": 100, "bought": false},
		SkinType.SPEARMEN: {"rect": Rect2(952, 772, 146, 133), "position": Vector2(0, -66), "price": 100, "bought": false},
		SkinType.MAGICIAN: {"rect": Rect2(948, 925, 148, 154), "position": Vector2(0, -77), "price": 100, "bought": false},
		SkinType.PIRATE: {"rect": Rect2(956, 1122, 113, 140), "position": Vector2(0, -70), "price": 100, "bought": false},
		SkinType.SHERIFF: {"rect": Rect2(958, 1311, 117, 129), "position": Vector2(0, -65), "price": 100, "bought": false},
		SkinType.COFFEE: {"rect": Rect2(954, 1487, 138, 133), "position": Vector2(0, -66), "price": 100, "bought": false},
	},
	Type.RABBIT:{
		SkinType.DEFAULT: {"rect": Rect2(1165, 41, 82, 136), "position": Vector2(0, -68), "price": 100, "bought": false},
		SkinType.SCOUT: {"rect": Rect2(1163, 220, 83, 135), "position": Vector2(0, -68), "price": 100, "bought": false},
		SkinType.CROCODILE: {"rect": Rect2(1165, 400, 82, 135), "position": Vector2(0, -68), "price": 100, "bought": false},
		SkinType.WAITER: {"rect": Rect2(1154, 582, 121, 136), "position": Vector2(0, -68), "price": 100, "bought": false},
		SkinType.SPEARMEN: {"rect": Rect2(1149, 768, 114, 141), "position": Vector2(0, -68), "price": 100, "bought": false},
		SkinType.MAGICIAN: {"rect": Rect2(1163, 937, 117, 144), "position": Vector2(0, -71), "price": 100, "bought": false},
		SkinType.PIRATE: {"rect": Rect2(1162, 1126, 86, 135), "position": Vector2(0, -68), "price": 100, "bought": false},
		SkinType.SHERIFF: {"rect": Rect2(1160, 1307, 92, 136), "position": Vector2(0, -68), "price": 100, "bought": false},
		SkinType.COFFEE: {"rect": Rect2(1173, 1486, 107, 136), "position": Vector2(0, -68), "price": 100, "bought": false},
	},
	Type.DEER:{
		SkinType.DEFAULT: {"rect": Rect2(1350, 17, 102, 159), "position": Vector2(0, -79), "price": 100, "bought": false},
		SkinType.SCOUT: {"rect": Rect2(1348, 197, 102, 158), "position": Vector2(0, -79), "price": 100, "bought": false},
		SkinType.CROCODILE: {"rect": Rect2(1347, 377, 102, 159), "position": Vector2(0, -79), "price": 100, "bought": false},
		SkinType.WAITER: {"rect": Rect2(1336, 562, 128, 158), "position": Vector2(0, -79), "price": 100, "bought": false},
		SkinType.SPEARMEN: {"rect": Rect2(1334, 743, 118, 159), "position": Vector2(0, -79), "price": 100, "bought": false},
		SkinType.MAGICIAN: {"rect": Rect2(1341, 914, 135, 166), "position": Vector2(0, -83), "price": 100, "bought": false},
		SkinType.PIRATE: {"rect": Rect2(1350, 1102, 102, 158), "position": Vector2(0, -79), "price": 100, "bought": false},
		SkinType.SHERIFF: {"rect": Rect2(1341, 1277, 103, 163), "position": Vector2(0, -82), "price": 100, "bought": false},
		SkinType.COFFEE: {"rect": Rect2(1346, 1463, 115, 158), "position": Vector2(0, -79), "price": 100, "bought": false},
	},
	Type.LION:{
		SkinType.DEFAULT: {"rect": Rect2(1528, 31, 118, 143), "position": Vector2(0, -72), "price": 100, "bought": false},
		SkinType.SCOUT: {"rect": Rect2(1525, 211,118, 143), "position": Vector2(0, -72), "price": 100, "bought": false},
		SkinType.CROCODILE: {"rect": Rect2(1525, 393, 118, 144), "position": Vector2(0, -72), "price": 100, "bought": false},
		SkinType.WAITER: {"rect": Rect2(1515, 574, 136, 144), "position": Vector2(0, -72), "price": 100, "bought": false},
		SkinType.SPEARMEN: {"rect": Rect2(1524, 759, 143, 144), "position": Vector2(0, -72), "price": 100, "bought": false},
		SkinType.MAGICIAN: {"rect": Rect2(1518, 925, 141, 157), "position": Vector2(0, -78), "price": 100, "bought": false},
		SkinType.PIRATE: {"rect": Rect2(1528, 1118, 118, 144), "position": Vector2(0, -72), "price": 100, "bought": false},
		SkinType.SHERIFF: {"rect": Rect2(1533, 1297, 119, 143), "position": Vector2(0, -72), "price": 100, "bought": false},
		SkinType.COFFEE: {"rect": Rect2(1540, 1478, 124, 143), "position": Vector2(0, -72), "price": 100, "bought": false},
	},
	Type.HUMANS:{
		SkinType.DEFAULT: {"rect": Rect2(465, 327, 111, 168), "position": Vector2(0, -85), "price": 100, "bought": false},
		SkinType.SCOUT: {"rect": Rect2(698, 1344, 122, 187), "position": Vector2(0, -95), "price": 100, "bought": false},
		SkinType.CROCODILE: {"rect": Rect2(7, 1340, 200, 197), "position": Vector2(0, -98), "price": 100, "bought": false},
		SkinType.MAGICIAN: {"rect": Rect2(234, 1596, 184, 210), "position": Vector2(0, -107), "price": 100, "bought": false},
		SkinType.SHERIFF: {"rect": Rect2(29, 1613, 155, 187), "position": Vector2(0, -95), "price": 100, "bought": false},
		SkinType.FARMER: {"rect": Rect2(444, 1582, 195, 218), "position": Vector2(0, -110), "price": 100, "bought": false},
		SkinType.COFFEE: {"rect": Rect2(900, 1345, 150, 187), "position": Vector2(0, -95), "price": 100, "bought": false},
		SkinType.HALLOWEEN: {"rect": Rect2(242, 1330, 157, 203), "position": Vector2(0, -102), "price": 100, "bought": false},
		SkinType.CATMAN: {"rect": Rect2(452, 1335, 161, 193), "position": Vector2(0, -98), "price": 100, "bought": false},
		SkinType.POTATO: {"rect": Rect2(887, 1087, 135, 191), "position": Vector2(0, -97), "price": 100, "bought": false},
		SkinType.HAMBURGER: {"rect": Rect2(686, 1092, 138, 183), "position": Vector2(0, -91), "price": 100, "bought": false},
		SkinType.KNIGHT: {"rect": Rect2(461, 1081, 149, 196), "position": Vector2(0, -98), "price": 100, "bought": false},
		SkinType.ADVENTURER: {"rect": Rect2(242, 1108, 147, 167), "position": Vector2(0, -85), "price": 100, "bought": false},
		SkinType.ARCHER: {"rect": Rect2(39, 1101, 154, 174), "position": Vector2(0, -87), "price": 100, "bought": false},
	}
}

func get_player_skin(type: Type, skin: SkinType):
	return skins[type][skin]

func get_skin_price(type: Type, skin: SkinType):
	return skins[type][skin].price

func get_skin_bought(type: Type, skin: SkinType) -> bool:
	return skins[type][skin].bought
	
func  set_skin_bought(type: Type, skin: SkinType):
	skins[type][skin].bought = true

func buy_skin(type: Type, skin: SkinType):
	set_skin_bought(type, skin)
	pass
