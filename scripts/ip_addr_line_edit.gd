extends EditOnFocusLineEdit

@export var dependant_btn: Button
@export var error_label: Label

func _ready() -> void:
	super._ready()
	
	text = NetworkManager.LAST_SERVER_IP
	
	text_changed.connect(_on_text_changed)
	_on_text_changed(text)

func _on_text_changed(new_text: String) -> void:
	if not new_text.is_empty() and (is_ipv4(new_text) or is_ipv6(new_text)):
		dependant_btn.disabled = false
		error_label.hide()
	else:
		dependant_btn.disabled = true
		error_label.show()

func is_ipv4(string: String) -> bool:
	var ipv4_regex := RegEx.new()
	ipv4_regex.compile("^((25[0-5]|2[0-4][0-9]|1[0-9][0-9]|([1-9])?[0-9])(\\.(?!$)|$)){4}$")
	
	if ipv4_regex.search(string):
		return true
	else:
		return false

func is_ipv6(string: String) -> bool:
	var ipv6_regex := RegEx.new()
	ipv6_regex.compile("^((([0-9A-Fa-f]{1,4}:){1,6}:)|(([0-9A-Fa-f]{1,4}:){7}))([0-9A-Fa-f]{1,4})$")
	
	if ipv6_regex.search(string):
		return true
	else:
		return false
