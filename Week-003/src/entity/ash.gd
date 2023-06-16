extends Sprite2D

@onready var area = $Area2D
@export var value = 1000

func _ready():
	pass

func _physics_process(_delta):
	if not area.has_overlapping_bodies(): return
	
	var obj = area.get_overlapping_bodies()[0]
	obj.get_more_ash(self.value)
	self.queue_free()
