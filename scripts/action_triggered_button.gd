extends Button

@export var action: String = "ui_cancel"

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed(action) and is_visible_in_tree():
		pressed.emit()
