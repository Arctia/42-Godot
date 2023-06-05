extends Sprite2D

var max_fuel:float
var fuel:float

var arc:float = 274

func _process(_d):
	var percentage:float = (fuel / max_fuel) * 100
	%lbl_perc.text = str(snapped(percentage, 1)) + "%"
	var r = percentage * arc / 100
	%Arrow.rotation_degrees = r - arc
