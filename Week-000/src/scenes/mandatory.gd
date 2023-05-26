extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta_):
	speedmeter(%Taxi.velocity)

func speedmeter(v:Vector2):
	var t_speed:float = snapped(sqrt(pow(v.x, 2) + pow(v.y, 2)) / 10 * 1.37, 0.01)
	%lbl_speed_value.text = str(t_speed) + " km/h"
