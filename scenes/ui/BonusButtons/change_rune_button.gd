extends TextureButton

signal change_symbol

@onready var count_text: Label = $Count

var has_bonus: bool = false
var count

func  _ready() -> void:
	update_bonus_count()
	update_visibility()

func _on_pressed() -> void:
	if has_bonus:
		use_bonus()

func update_visibility():
	if has_bonus:
		modulate = Color(1,1,1,1)
	else:
		modulate = Color(1,1,1,0.5)

func update_bonus_count():
	count = PlayerStats.get_bonuses("CHANGE_RUNE")
	if count > 0:
		has_bonus = true
	else :
		has_bonus = false
	count_text.text = str(count)

func use_bonus():
	PlayerStats.add_bonus(Bonuses.BonusType.CHANGE_RUNE, -1)
	update_bonus_count()
	update_visibility()
	emit_signal("change_symbol")
