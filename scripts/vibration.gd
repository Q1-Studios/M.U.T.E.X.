extends Node

var controller_id: int = 0

func _ready() -> void:
	update_controller_id()

func _input(event: InputEvent) -> void:
	if event is InputEventJoypadButton or event is InputEventJoypadMotion:
		update_controller_id()

func update_controller_id() -> void:
	if not Input.get_connected_joypads().is_empty():
		controller_id = Input.get_connected_joypads()[0]

func vibrate(weak_magnitude: float, strong_magnitude: float, duration: float) -> void:
	Input.start_joy_vibration(controller_id, weak_magnitude, strong_magnitude, duration)
