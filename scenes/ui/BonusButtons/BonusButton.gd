extends TextureButton


@onready var texture_rect: TextureRect = $TextureRect
@onready var texture_progress_bar: TextureProgressBar = $TextureProgressBar
@onready var count: Label = $Count
@onready var timer: Timer = $Timer

var btn_pressed = false

func  _ready() -> void:
	texture_progress_bar.max_value = timer.wait_time

func _process(_delta: float) -> void:
	if btn_pressed:
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
