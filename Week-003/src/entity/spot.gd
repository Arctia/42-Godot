extends Area2D

var active:bool = false
var distance:float
var score:int
signal release

func _ready():
	self.visible = false

func _process(_d_):
	if not self.active: return
	if self.has_overlapping_bodies():
		for body in self.get_overlapping_bodies():
			if body.name == "Taxi":
				body.score += score
				body.passenger = false
				body.fuel += 10 / float(score / 10)
				_deactivate()
				release.emit()

func _deactivate():
	self.active = false
	self.visible = false

func _activate():
	self.active = true
	self.visible = true

