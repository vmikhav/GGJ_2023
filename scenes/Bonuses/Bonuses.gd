extends Node


var icon_milk = load("res://themes/forest/assets/reward 3.png")
var icon_bomb = load("res://themes/forest/assets/reward 4.png")
var icon_change_rune = load("res://themes/forest/assets/reward 2.png")

enum BonusType{
	MILK,
	BOMB,
	CHANGE_RUNE
}

var bonuses = {
	BonusType.MILK:{"icon": icon_milk, "price": 10},
	BonusType.BOMB:{"icon": icon_bomb, "price": 20},
	BonusType.CHANGE_RUNE:{"icon": icon_change_rune,"price": 30}
}
func get_price(bonus_type: BonusType) -> int:
	return bonuses[bonus_type].price
