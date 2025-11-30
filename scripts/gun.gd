extends Node3D

@onready var gun_ray = $RayCast3D

# Ensure this matches your file path EXACTLY
var missile_scene = load("res://scenes/Missile.tscn")

signal spawnMissileClicked(isHost:bool, position, transform)

func _process(_delta):
	# Input Guard: Only the local player can request a shot
	if not owner.is_multiplayer_authority():
		return
		
	if Input.is_action_just_pressed("shoot"):
		# Networking Check
		if multiplayer.is_server():
			spawnMissileClicked.emit(true, gun_ray.global_position, gun_ray.global_transform.basis)
		else:
			spawnMissileClicked.emit(false, gun_ray.global_position, gun_ray.global_transform.basis)
	
