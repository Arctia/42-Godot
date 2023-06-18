extends Control

#--- Variables ----------------------------------------------------------------#
#--- Variables
#------------------------------------------------------------------------------#

var meters:float = 0
var gameover:bool = false
var active_spot = null

#--- Process methods ----------------------------------------------------------#
#--- Process methods
#------------------------------------------------------------------------------#
 
func _ready() -> void:
	%lbl_score2.text = "hi-score: " + str(GL.high_score)
	initialize()
	$scene/Taxi/AnimationPlayer.play("arrow_anim")

func _process(delta) -> void:
	if Input.is_action_just_pressed("pause"): _set_pause()
	if get_tree().paused: return
	speedmeter(%Taxi.velocity, delta)
	manometro_info()
	check_death()
	move_camera()
	check_passengers()
	check_score()
	set_arrow()

func initialize() -> void:
	%Manometro.max_fuel = %Taxi.MAX_FUEL

#--- Other Methods ------------------------------------------------------------#
#--- Other Methods
#------------------------------------------------------------------------------#

func speedmeter(v:Vector2, delta) -> void:
	var t_speed:float = snapped(sqrt(pow(v.x, 2) + pow(v.y, 2)) / 10 * 1.37, .01)
	%lbl_speed_value.text = str(t_speed) + " km/h"
	self.meters += (t_speed / 3.6) * delta
	if self.meters >= 1000:
		%lbl_meters_value.text = str(snapped(self.meters/1000, 0.01)) + " km"
	else:
		%lbl_meters_value.text = str(snapped(self.meters, 0.01)) + " m"

func manometro_info() -> void:
	%Manometro.fuel = %Taxi.fuel

func check_death() -> void:
	if %Taxi.fuel <= 0 and not self.gameover: 
		self.gameover = true
		set_score()
		$AnimationPlayer.play("GameOver")

func _on_btn_title_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://src/scenes/Title.tscn")

func _set_pause() -> void:
	var pause = %PauseHover
	get_tree().paused = true if not get_tree().paused else false
	pause.visible = true if not pause.visible else false
	if pause.visible:
		$AnimationPlayer.play("Pause_Anim")

func _on_animation_player_animation_finished(anim_name) -> void:
	if anim_name == "Pause_Anim" and get_tree().paused:
		$AnimationPlayer.play("Pause_Anim")

func move_camera() -> void:
	%Camera2D.position = %Taxi.position

# ---------------------------------------------------------------------------- #
# .. Week 3 methods

func check_passengers() -> void:
	if %Taxi.passenger: return
	
	var passengers = 0
	for child in %passengers.get_children():
		if child.active: passengers += 1
	
	if passengers != 0: return 
	for child in %passengers.get_children():
		child._activate()

func sort_method(a, b) -> bool:
	if a.distance < b.distance:
		return true
	return false

func _on_passenger_passenger_in(diff) -> void:
	# based on difficulty spawn release spot
	var elements = []
	for spot in %release_spots.get_children():
		spot.distance = %Taxi.position.distance_squared_to(spot.position)
		elements.append(spot)
	elements.sort_custom(sort_method)
	
#	var choiche = diff - randi_range(0, 2)
#	if choiche > len(elements) - 1: choiche = len(elements) - 1
	
	var choiche = randi_range(0, len(elements) - 1)
	
	self.active_spot = elements[choiche]
	active_spot.score = int((diff * meters) / 4)
	active_spot._activate()
	
	raise_difficulty()

func raise_difficulty() -> void:
	for child in %passengers.get_children(): 
		child.difficulty += 1
		child._stop_animation()

func _on_spot_release() -> void:
	self.active_spot = null
	for child in %passengers.get_children(): 
		child._play_animation()

func check_score() -> void:
	%lbl_score.text = "   score: " + str(%Taxi.score)

func _on_button_2_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://src/scenes/mandatory.tscn")

func set_score() -> void:
	if %Taxi.score > GL.high_score:
		%lbl_result.text = "NEW HIGH SCORE!! " + str(%Taxi.score)
		GL.high_score = %Taxi.score
		%lbl_score2.text = "hi-score: " + str(GL.high_score)
	else:
		%lbl_result.text = "score: " + str(%Taxi.score) + " retry to beat " + str(GL.high_score)

func set_arrow() -> void:
	if active_spot != null:
		%arrow.visible = true
		%arrow.rotation = %Taxi.position.angle_to_point(Vector2(active_spot.position.x + 16, active_spot.position.y + 20)) - deg_to_rad(45)
	else:
		%arrow.visible = false
