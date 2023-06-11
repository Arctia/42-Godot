extends Control

@onready var h_bar = $health/bar

func _ready():
	h_bar.set_max($Ashes.ashes_full)
	h_bar.set_value($Ashes.ashes_amount)

func _on_ashes_consume_ashes(arg):
	h_bar.value = arg

func _input(event):
	if event.is_action_pressed("move_left"): %btn_left.button_pressed = true
	if event.is_action_pressed("move_right"): %btn_right.button_pressed = true
	if event.is_action_pressed("jump"): %btn_jump.button_pressed = true
	if event.is_action_released("jump"): %btn_jump.button_pressed = false
	if event.is_action_released("move_left"): %btn_left.button_pressed = false
	if event.is_action_released("move_right"): %btn_right.button_pressed = false
