extends EditOnFocusLineEdit

@export var dependant_btn: Button
@export var error_label: Label

func _ready() -> void:
	super._ready()
	
	text = NetworkManager.LAST_SERVER_IP
	
	text_changed.connect(_on_text_changed)
	_on_text_changed(text)

func _on_text_changed(new_text: String) -> void:
	if not new_text.is_empty() and (IpAddressDetector.is_ipv4(new_text) or IpAddressDetector.is_ipv6(new_text)):
		dependant_btn.disabled = false
		error_label.hide()
	else:
		dependant_btn.disabled = true
		error_label.show()
