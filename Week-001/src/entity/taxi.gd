extends CharacterBody2D

@export var ACC:float = 0
@export var MAX_SPEED:float = 400
var FRICTION:float

func _ready():
	FRICTION = ACC

func _physics_process(delta):
	var xaxis = Input.get_axis("move_left", "move_right")
	var yaxis = Input.get_axis("move_up", "move_down")
	
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
	
	var coll:KinematicCollision2D = move_and_collide(velocity * delta)
	if coll:
#		var c_angle:float = deg_to_rad(coll.get_angle())
#
#		if (c_angle > 45 and c_angle < 135) or (c_angle < -45 and c_angle > -135):
#			velocity.y = 0
#		elif (c_angle > 135 and c_angle < 225) or (c_angle > -45 and c_angle < 45):
#			velocity.x = 0
#		else:
#			velocity = Vector2.ZERO
		velocity = Vector2.ZERO
