extends EditOnFocusLineEdit

@export var color_picker: ColorPicker
@export var preview: ColorRect
@export var invalid_symbol: CanvasItem

func _ready() -> void:
	super._ready()
	
	color_picker.hide()
	invalid_symbol.hide()
	color_picker.color = Color(text)
	preview.color = Color(text)
	
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

func _on_text_changed(new_text: String) -> void:
	if Color.html_is_valid(new_text):
		var new_color: Color = Color(new_text)
		color_picker.color = new_color
		preview.color = new_color
		invalid_symbol.hide()
	else:
		invalid_symbol.show()

func _on_color_picker_changed(color: Color) -> void:
	text = "#" + color.to_html(false)
	preview.color = color
	invalid_symbol.hide()

func get_children_recursive(node: Node = self) -> Array[Node]:
	var result: Array[Node] = []
	for child in node.get_children(true):
		result.append(child)
		result.append_array(get_children_recursive(child))
	return result
