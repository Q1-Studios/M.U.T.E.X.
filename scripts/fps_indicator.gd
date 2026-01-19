extends Label

func _ready() -> void:
	if not OS.is_debug_build():
		hide()

func _process(delta: float) -> void:
	if visible:
		text = str(int(1 / delta)) + " fps"
