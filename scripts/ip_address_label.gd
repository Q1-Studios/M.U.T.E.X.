extends CopyOnClickLabel
class_name IPAddressLabel

@export var ip_type: IpAddressDetector.AddressType

func refresh_ip() -> void:
	var ips = IpAddressDetector.get_ips(ip_type)
	if ips.size() > 0:
		text = ips[0]
	else:
		text = "Couldn't find your IP :("
