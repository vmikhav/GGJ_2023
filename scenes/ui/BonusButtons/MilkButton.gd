extends TextureButton

signal milk_bonus

@onready var texture_rect: TextureRect = $TextureRect
@onready var texture_progress_bar: TextureProgressBar = $TextureProgressBar
@onready var count: Label = $Count
@onready var timer: Timer = $Timer

var btn_pressed: bool = false
var has_bonus: bool = false

func  _ready() -> void:
	update_visibility()
	texture_progress_bar.max_value = timer.wait_time

func _process(_delta: float) -> void:
	if btn_pressed and has_bonus:
		emit_signal("milk_bonus")
		texture_progress_bar.value = timer.time_left
		disabled = true
	else :
		return

func _on_timer_timeout() -> void:
	disabled = false
	btn_pressed = false


func _on_pressed() -> void:
	timer.start()
	btn_pressed = true

func update_visibility():
	if has_bonus:
		modulate = Color(1,1,1,1)
	else:
		modulate = Color(1,1,1,0.5)
