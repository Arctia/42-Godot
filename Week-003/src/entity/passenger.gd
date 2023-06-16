@tool
extends Area2D

signal passenger_in(diff)

@export var difficulty:float = 2
var active:bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
#	self.visible = false
	self.pax_choice()
	$AnimationPlayer.play("jumping")

func pax_choice() -> void:
	randomize()
	var i = randi_range(1, 4)
	$Sprite2D.set_texture(load("res://assets/objects/pax" + str(i) + ".png"))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_dt) -> void:
	if self.active and self.has_overlapping_bodies():
		for body in self.get_overlapping_bodies():
			if body.name == "Taxi" and not body.passenger:
				var player = body
				player.passenger = true
				passenger_in.emit(self.difficulty)
				self._deactivate()

func _stop_animation() -> void:
	$AnimationPlayer.play("RESET")
	$AnimationPlayer.stop()

func _play_animation() -> void:
	$AnimationPlayer.play("jumping")

func _deactivate() -> void:
	self.active = false
	self.visible = false

func _activate() -> void:
	self.active = true
	self.pax_choice()
	self.visible = true
