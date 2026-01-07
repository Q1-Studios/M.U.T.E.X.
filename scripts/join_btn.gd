extends Button

@export var ip_field: LineEdit

func _process(_delta: float) -> void:
	if(ip_field.text != ""):
		disabled = false
	else:
		disabled = true
