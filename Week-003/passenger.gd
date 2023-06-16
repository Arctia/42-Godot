extends Area2D

@export var distance:float

func _physics_process(delta):
	if has_overlapping_bodies():
		get_overlapping_bodies()[0].get_passenger(self)
		self.queue_free()
