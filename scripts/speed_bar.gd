extends TextureProgressBar
var current_speed = 0
@export var playerMovementNode: Node3D
@export var player:CharacterBody3D
var playerSpeedVar: int = 0
@export var speedColor:Color
@export var boostColor:Color
@export var gradient: Gradient

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	update_speed()

func update_speed():
	if not player:
		return
	playerSpeedVar = player.velocity.length()
	value = playerSpeedVar
	#if gradient and max_value > 0:
		#var ratio = value / 120
		#tint_progress = gradient.sample(ratio)
