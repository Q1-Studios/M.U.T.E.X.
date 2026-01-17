extends LineEdit
class_name EditOnFocusLineEdit

var block_key_nav: bool = false

func _ready() -> void:
	focus_entered.connect(_on_focus_entered)

func _on_focus_entered() -> void:
	edit()
	caret_column = text.length()
	block_key_nav = true

func _process(_delta: float) -> void:
	if is_editing() and not block_key_nav:
		if Input.is_action_just_pressed("ui_up"):
			grab_focus_if_exists(focus_neighbor_top)
		if Input.is_action_just_pressed("ui_down"):
			grab_focus_if_exists(focus_neighbor_bottom)
	block_key_nav = false

func grab_focus_if_exists(path: NodePath) -> void:
	var next_node: Control = get_node(path)
	if next_node != null:
		next_node.grab_focus()
