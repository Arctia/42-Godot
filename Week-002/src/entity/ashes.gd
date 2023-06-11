extends CharacterBody2D

signal setup_ashes(total_ash, current_ash)
signal consume_ashes(new_value)

@export var ACC:float = 0
@export var MAX_SPEED:float = 400
@export var JUMP:float = -700
var FRICTION:float
var moving:bool = false
var idle:float = 0.0

@export var ashes_full:float = 100000
@export var ashes_amount:float = 100000

var gravity:float = ProjectSettings.get_setting("physics/2d/default_gravity") *1.5
var is_jumping:bool = true

func _ready():
	FRICTION = ACC

func _physics_process(delta):
	if self.move(delta): self.reduce_ashes(delta)
	self.jumping(delta)
	self.check_anim()
	self.rotating(delta)
	move_and_slide()

func move(_delta) -> bool:
	var xaxis = Input.get_axis("move_left", "move_right")
	if xaxis and self.ashes_amount > 0: velocity.x += xaxis * ACC
	else: velocity.x = move_toward(velocity.x, 0, FRICTION/2)
	velocity.x = clampf(velocity.x, -MAX_SPEED, MAX_SPEED)
	if velocity.x != 0: return true
	return false

func jumping(delta) -> void:
	if not is_on_floor(): velocity.y += gravity * delta
	elif Input.is_action_just_pressed("jump") and self.ashes_amount > 0: 
		velocity.y += JUMP
		self.ashes_amount -= abs(JUMP) * delta
		consume_ashes.emit(self.ashes_amount)

func reduce_ashes(delta) -> void:
	if self.ashes_amount > 0: 
		self.ashes_amount -= abs(velocity.x) * delta
		consume_ashes.emit(self.ashes_amount)
	else: velocity.x = 0

func rotating(delta) -> void:
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

func open_eyes() -> void:
	if not moving: return
	moving = false
	$AnimationPlayer.play("Open_Eyes")

func close_eyes() -> void:
	if moving: return
	moving = true
	$AnimationPlayer.play("Close_Eyes")

func get_more_ash(value:float) -> void:
	self.ashes_amount += value
	if self.ashes_amount > self.ashes_full: self.ashes_amount = self.ashes_full
	consume_ashes.emit(self.ashes_amount)
