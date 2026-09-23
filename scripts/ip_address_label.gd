extends CopyOnClickLabel
class_name IPAddressLabel

@export var ip_type: IpAddressDetector.AddressType
@export var auto_type: bool = false

func refresh_ip() -> void:
	if auto_type:
		ip_type = IpAddressDetector.get_best_type()
	
	var ips = IpAddressDetector.get_ips(ip_type)
	if ips.size() > 0:
		text = ips[0]
	else:
		text = "Couldn't find your IP :("
