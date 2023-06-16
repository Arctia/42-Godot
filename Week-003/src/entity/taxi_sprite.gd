extends Sprite2D

@export var EDGE_SZ:int = 16

func keydown(key:StringName) -> bool:
	if Input.is_action_pressed(key): 
		return true
	return false

func multiple_keydown(key0:StringName, key1:StringName) -> bool:
	if keydown(key0) and keydown(key1):
		return true
	return false

func _process(_delta_):
	if InputEvent:
		if multiple_keydown("move_up", "move_right"): self.change_sprite(4)
		elif multiple_keydown("move_up", "move_left"): self.change_sprite(5)
		elif multiple_keydown("move_down", "move_left"): self.change_sprite(6)
		elif multiple_keydown("move_down", "move_right"): self.change_sprite(7)
		elif Input.is_action_pressed("move_up"): self.change_sprite(0)
		elif Input.is_action_pressed("move_down"): self.change_sprite(1)
		elif Input.is_action_pressed("move_right"): self.change_sprite(2)
		elif Input.is_action_pressed("move_left"): self.change_sprite(3) 

func change_sprite(direction:int):
	var r:Rect2
	var sz:int = EDGE_SZ
	var angle:float = 0
	
	match direction:
		0: r = Rect2(0, sz, sz, sz)
		1: r = Rect2(sz, 0, sz, sz)
		2: r = Rect2(0, 0, sz, sz)
		3: r = Rect2(sz, sz, sz, sz)
		4: r = Rect2(0, sz, sz, sz); angle = deg_to_rad(45)
		5: r = Rect2(0, sz, sz, sz); angle = deg_to_rad(-45)
		6: r = Rect2(sz, 0, sz, sz); angle = deg_to_rad(45)
		7: r = Rect2(sz, 0, sz, sz); angle = deg_to_rad(-45)
	
	self.region_rect = r
	self.rotation = angle
