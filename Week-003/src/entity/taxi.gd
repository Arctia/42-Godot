extends CharacterBody2D

@export var ACC:float = 0
@export var MAX_SPEED:float = 400
@export var MAX_FUEL:float = 40

@export var fuel:float = 1

var FRICTION:float

var passenger:bool = false
var score:int = 0

func _ready():
	FRICTION = ACC

func _physics_process(delta):
	if fuel > MAX_FUEL: fuel = MAX_FUEL
	
	var xaxis = Input.get_axis("move_left", "move_right")
	var yaxis = Input.get_axis("move_up", "move_down")
	
	if (xaxis or yaxis) and fuel <= 0: xaxis = 0; yaxis = 0; fuel = 0
	elif (xaxis or yaxis) and fuel > 0: fuel -= 0.01
	
	if xaxis and yaxis:
		velocity.x += xaxis * ACC * cos(deg_to_rad(45))
		velocity.y += yaxis * ACC * sin(deg_to_rad(45))
		var mx = cos(velocity.angle()) * MAX_SPEED
		var my = sin(velocity.angle()) * MAX_SPEED
		if mx < 0: mx = mx * -1
		if my < 0: my = my * -1
		velocity.x = clamp(velocity.x, -mx, mx)
		velocity.y = clamp(velocity.y, -my, my)
	elif xaxis:
		velocity.x += xaxis * ACC
		velocity.y = move_toward(velocity.y, 0, FRICTION)
	elif yaxis:
		velocity.y += yaxis * ACC
		velocity.x = move_toward(velocity.x, 0, FRICTION)
	else:
		velocity.x = move_toward(velocity.x, 0, FRICTION)
		velocity.y = move_toward(velocity.y, 0, FRICTION) 
	
	velocity.x = clampf(velocity.x, -MAX_SPEED, MAX_SPEED)
	velocity.y = clampf(velocity.y, -MAX_SPEED, MAX_SPEED)
	
	do_collision(move_and_collide(velocity * delta))

func do_collision(coll:KinematicCollision2D):
	if not coll: return
	var obj:Object = coll.get_collider()
	if obj.get_class() in ["TileMap", "StaticBody2D"]:
		velocity = Vector2.ZERO
	elif obj.get_class() == "RigidBody2D":
		obj.apply_force(velocity*4)
		velocity.x -= velocity.x / 10
		velocity.y -= velocity.y / 10
	
