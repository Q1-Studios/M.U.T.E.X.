extends LineEdit

@export var dependant_btn: Button
@export var error_label: Label

func _ready() -> void:
	text = NetworkManager.LAST_SERVER_IP
	
	focus_entered.connect(_on_focus_entered)
	text_changed.connect(_on_text_changed)
	_on_text_changed(text)

func _on_focus_entered() -> void:
	edit()
	caret_column = text.length()

func _on_text_changed(new_text: String) -> void:
	if not new_text.is_empty() and is_ip(new_text):
		dependant_btn.disabled = false
		error_label.hide()
	else:
		dependant_btn.disabled = true
		error_label.show()

func is_ip(string: String) -> bool:
	var ip_regex := RegEx.new()
	ip_regex.compile("^((25[0-5]|2[0-4][0-9]|1[0-9][0-9]|([1-9])?[0-9])(\\.(?!$)|$)){4}$")
	
	if ip_regex.search(string):
		return true
	else:
		return false
