extends LineEdit

func _ready() -> void:
	focus_entered.connect(_on_focus_entered)

func _on_focus_entered() -> void:
	edit()
	caret_column = text.length()
