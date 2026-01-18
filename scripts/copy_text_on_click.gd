extends Label

@export var copied_notification: CanvasItem

var mouse_inside: bool = false

func _ready() -> void:
	copied_notification.modulate.a = 0
	
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func _process(delta: float) -> void:
	if copied_notification.modulate.a > 0:
		copied_notification.modulate.a -= delta

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		if mouse_inside and is_visible_in_tree():
			DisplayServer.clipboard_set(text)
			copied_notification.modulate.a = 1

func _on_mouse_entered() -> void:
	mouse_inside = true
	modulate.a = 0.8

func _on_mouse_exited() -> void:
	mouse_inside = false
	modulate.a = 1
