extends Node3D


@export var player : CharacterBody3D 
@export var timeTillAutoStop := 5.0
# speed in meters/second; acceleration in meters/second^2
@export var MAX_SPEED := 30
@export var MIN_SPEED := -15.0
@export var acceleration := 7

var defaultAcceleration :=  -MAX_SPEED / timeTillAutoStop
@export var decceleration := -10
# degrees/second
@export var yaw_speed := 50.0 
@export var pitch_speed := 90.0
@export var roll_speed := 120.0


# 0.0 means no coupled yaw. 1.0 means strong turning when rolling.
# 0.5 is usually a "sweet spot" for arcade feel.
@export_range(0.0, 2.0) var coupled_yaw_amount := 1

# CONTROLS FEEL
# Higher = Snappy/Robotic. Lower = Heavy/Smooth.
# 10.0 is a good balance for precision.
@export var response_speed := 5.0

# TURN ASSIST (Auto-Pitch): 
# When rolling, this automatically "Pulls Up" to create a curve.
# 0.0 = Fly straight when rolled (Hard). 
# 1.0 = Tight turns automatically when rolled (Easy).
@export_range(0.0, 0.0) var turn_assist_amount := 2

@export var auto_level_speed := 2.0


var current_speed
var current_pitch_input := 0.0
var current_roll_input := 0.0
var current_yaw_input := 0.0


func _ready():
	if not player:
		player = get_parent()
		
	pitch_speed = deg_to_rad(pitch_speed)
	yaw_speed = deg_to_rad(yaw_speed)
	roll_speed = deg_to_rad(roll_speed)
	
	current_speed = 0.0
	print("movementcontroller Initialized")

func _physics_process(delta):
	var raw_pitch = Input.get_axis("TiltDown", "TiltUp")
	var raw_roll = Input.get_axis("RollRight", "RollLeft")
	var acceleration_direction = Input.get_axis("Accelerate", "Break")
	var manual_yaw = 0.0
	
		# Only auto-level if the player is NOT trying to roll manually
	if raw_roll == 0:
		# We check the Y value of the ship's RIGHT vector (Basis.x).
		# If Basis.x.y is positive, the right wing is pointing up.
		# We multiply by auto_level_speed to create a correction force.
		var leveling_force = -player.transform.basis.x.y * auto_level_speed
		
		# Prevent leveling if we are flying straight up/down (Gimbal lock prevention)
		# basis.z.y is our Pitch. If it's near 1 or -1, we are vertical.
		if abs(player.transform.basis.z.y) < 0.9:
			player.rotate_object_local(Vector3.BACK, leveling_force * delta)
	
	
	current_pitch_input = lerp(current_pitch_input, raw_pitch, delta * response_speed)
	current_roll_input = lerp(current_roll_input, raw_roll, delta * response_speed)
	
	
	# ASSISTS
	var auto_yaw = current_roll_input * coupled_yaw_amount 
	var final_yaw = manual_yaw + auto_yaw
	current_yaw_input = lerp(current_yaw_input, final_yaw, delta * response_speed)
	
	
	var auto_pitch = abs(current_roll_input) * turn_assist_amount
	var final_pitch = current_pitch_input + auto_pitch
	
	
	player.rotate_object_local(Vector3.BACK, current_roll_input * roll_speed * delta)
	player.rotate_object_local(Vector3.RIGHT, final_pitch * pitch_speed * delta)
	player.rotate_object_local(Vector3.UP, current_yaw_input * yaw_speed * delta)

	
	if acceleration_direction < 0:
		current_speed += acceleration * delta
	elif acceleration_direction > 0:
		current_speed += decceleration * delta
	else: 
		current_speed = move_toward(current_speed, 0.0, abs(defaultAcceleration) * delta)
	   
	current_speed = clamp(current_speed, MIN_SPEED, MAX_SPEED)
	player.velocity = -player.transform.basis.z * current_speed
	
	
	player.move_and_slide()
	
	if Input.is_action_just_pressed("RESET"):
		current_speed = 0.0
		player.position = Vector3.ZERO
		player.rotation = Vector3.ZERO
		
	
