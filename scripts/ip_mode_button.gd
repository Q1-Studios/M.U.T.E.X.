extends Button

@export var ip_label: IPAddressLabel

enum IpMode { AUTO, LOCAL_IPV4, LOCAL_IPV6, PUBLIC_IPV4, PUBLIC_IPV6 }

const modes: Array[IpMode] = [
	IpMode.AUTO,
	IpMode.LOCAL_IPV4,
	IpMode.LOCAL_IPV6,
	IpMode.PUBLIC_IPV4,
	IpMode.PUBLIC_IPV6
]
var current_index: int = 0

func _ready() -> void:
	var current_mode: IpMode = modes[current_index]
	show_ip_address_for_mode(current_mode)

func _on_pressed() -> void:
	current_index = (current_index + 1) % modes.size()
	var current_mode: IpMode = modes[current_index]
	show_ip_address_for_mode(current_mode)

func show_ip_address_for_mode(mode: IpMode) -> void:
	ip_label.auto_type = false
	
	match mode:
		IpMode.AUTO:
			ip_label.auto_type = true
			text = "Auto"
		IpMode.LOCAL_IPV4:
			ip_label.ip_type = IpAddressDetector.AddressType.LOCAL_IPV4
			text = "Local IPv4"
		IpMode.LOCAL_IPV6:
			ip_label.ip_type = IpAddressDetector.AddressType.LOCAL_IPV6
			text = "Local IPv6"
		IpMode.PUBLIC_IPV4:
			ip_label.ip_type = IpAddressDetector.AddressType.PUBLIC_IPV4
			text = "Public IPv4"
		IpMode.PUBLIC_IPV6:
			ip_label.ip_type = IpAddressDetector.AddressType.PUBLIC_IPV6
			text = "Public IPv6"
	
	ip_label.refresh_ip()
