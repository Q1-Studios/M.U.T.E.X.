extends CopyOnClickLabel
class_name IPAddressLabel

func refresh_ip() -> void:
	# Find all potential IPs that identify the host's local network adapters
	var ips: Array = []
	for ip in IP.get_local_addresses():
		if ip.begins_with("10.") or ip.begins_with("172.16.") or ip.begins_with("192.168."):
			ips.append(ip)
	if ips.size() > 0:
		text = ips[0]
	else:
		text = "Couldn't find your IP :("
