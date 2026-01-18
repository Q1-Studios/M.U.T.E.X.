extends CanvasItem

@export var fadeout_time: float = 1.0

func _ready() -> void:
	modulate.a = 0

func _process(delta: float) -> void:
	if modulate.a > 0:
		modulate.a -= delta * (1 / fadeout_time)
