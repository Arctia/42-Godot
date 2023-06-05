extends CharacterBody2D

@export var ACC:float = 0
@export var MAX_SPEED:float = 400
var FRICTION:float
var moving:bool = false
var idle:float = 0.0

const jump_acc:float = -200
var gravity:float = ProjectSettings.get_setting("physics/2d/default_gravity") *1.5

func _ready():
	FRICTION = ACC

func _physics_process(delta):
	var xaxis = Input.get_axis("move_left", "move_right")

	if xaxis: velocity.x += xaxis * ACC
	else: velocity.x = move_toward(velocity.x, 0, FRICTION/2)
	velocity.x = clampf(velocity.x, -MAX_SPEED, MAX_SPEED)
	
	if not is_on_floor(): velocity.y += gravity * delta
	
	self.check_anim()
	self.rotating(delta)
	move_and_slide()

func rotating(delta):
	if velocity.x != 0:
		self.idle = 0
		var grad:float = velocity.x / 100
		self.rotate(deg_to_rad(grad))
	else:
		self.idle += delta
		self.rotation = move_toward(self.rotation, 0.0, delta * 3)

func check_anim() -> void:
	if velocity == Vector2(0,0): self.open_eyes()
	else: self.close_eyes()
	if self.idle > 5:
		$AnimationPlayer.play("Idle")
		self.idle = 0

func open_eyes():
	if not moving: return
	moving = false
	$AnimationPlayer.play("Open_Eyes")

func close_eyes():
	if moving: return
	moving = true
	$AnimationPlayer.play("Close_Eyes")

