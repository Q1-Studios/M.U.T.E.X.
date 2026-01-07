extends LineEdit

@export var color_picker: ColorPicker
@export var preview: ColorRect

func _ready() -> void:
	color_picker.hide()
	color_picker.color = Color(text)
	preview.color = Color(text)
	
	focus_entered.connect(_on_focus_entered)
	text_changed.connect(_on_text_changed)
	color_picker.color_changed.connect(_on_color_picker_changed)
	get_viewport().gui_focus_changed.connect(_on_gui_focus_changed)

func _on_gui_focus_changed(control: Control) -> void:
	# Color picker consists of multiple internal children
	# Thus, a simple focus check does not suffice
	# Otherwise the color picker would be hidden despite being clicked
	if control == self or get_children_recursive().has(control):
		color_picker.show()
	else:
		color_picker.hide()

func _on_focus_entered() -> void:
	edit()
	caret_column = text.length()

func _on_text_changed(new_text: String) -> void:
	var new_color: Color = Color(new_text)
	color_picker.color = new_color
	preview.color = new_color

func _on_color_picker_changed(color: Color) -> void:
	text = "#" + color.to_html(false)
	preview.color = color

func get_children_recursive(node: Node = self) -> Array[Node]:
	var result: Array[Node] = []
	for child in node.get_children(true):
		result.append(child)
		result.append_array(get_children_recursive(child))
	return result
