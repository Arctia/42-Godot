extends Control

#--- Variables ----------------------------------------------------------------#
#--- Variables
#------------------------------------------------------------------------------#

var meters:float = 0
var gameover:bool = false

#--- Process methods ----------------------------------------------------------#
#--- Process methods
#------------------------------------------------------------------------------#
 
func _ready():
	initialize()

func _process(delta):
	if Input.is_action_just_pressed("pause"): _set_pause()
	if get_tree().paused: return
	speedmeter(%Taxi.velocity, delta)
	manometro_info()
	check_death()

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
		$AnimationPlayer.play("GameOver")

func _on_btn_title_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://src/scenes/Title.tscn")

func _set_pause() -> void:
	var pause = $PauseHover
	get_tree().paused = true if not get_tree().paused else false
	pause.visible = true if not pause.visible else false
	if pause.visible:
		$AnimationPlayer.play("Pause_Anim")

func _on_animation_player_animation_finished(anim_name) -> void:
	if anim_name == "Pause_Anim" and get_tree().paused:
		$AnimationPlayer.play("Pause_Anim")
