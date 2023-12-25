extends TextureButton

signal milk_bonus

@onready var texture_rect: TextureRect = $TextureRect
@onready var texture_progress_bar: TextureProgressBar = $TextureProgressBar
@onready var coun_text: Label = $Count
@onready var timer: Timer = $Timer
var count

var btn_pressed: bool = false
var has_bonus: bool = false
var is_use: bool = false

func  _ready() -> void:
	update_bonus_count()
	update_visibility()
	texture_progress_bar.max_value = timer.wait_time

func _process(_delta: float) -> void:
	if btn_pressed and has_bonus:
		use_bonus()
		texture_progress_bar.value = timer.time_left
		disabled = true
	else :
		return

func _on_timer_timeout() -> void:
	disabled = false
	btn_pressed = false
	is_use = false

func _on_pressed() -> void:
	if has_bonus:
		timer.start()
		btn_pressed = true

func update_visibility():
	if has_bonus:
		modulate = Color(1,1,1,1)
	else:
		modulate = Color(1,1,1,0.5)
	
func update_bonus_count():
	count = PlayerStats.get_bonuses("MILK")
	if count > 0:
		has_bonus = true
	else :
		has_bonus = false
	coun_text.text = str(count)

func use_bonus():
	if !is_use:
		is_use = true
		PlayerStats.add_bonus(Bonuses.BonusType.MILK, -1)
		update_bonus_count()
		update_visibility()
		milk_bonus.emit()
