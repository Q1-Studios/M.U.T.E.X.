extends Node

var local_ipv4s: Array[String] = []
var local_ipv6s: Array[String] = []
var public_ipv4s: Array[String] = []
var public_ipv6s: Array[String] = []

enum AddressType { LOCAL_IPV4, LOCAL_IPV6, PUBLIC_IPV4, PUBLIC_IPV6 }

func refresh_ips() -> void:
	# Find all potential IPs that may be used for connecting either locally or publicly
	local_ipv4s = []
	local_ipv6s = []
	public_ipv4s = []
	public_ipv6s = []
	
	for ip_res in IP.get_local_addresses():
		var ip = ip_res.to_lower()
		if is_ipv4(ip) and is_ipv4_local(ip):
			local_ipv4s.append(ip)
		elif is_ipv4(ip) and not is_ipv4_loopback(ip):
			public_ipv4s.append(ip)
		elif is_ipv6(ip) and is_ipv6_local(ip):
			local_ipv6s.append(ip)
		elif is_ipv6(ip) and not is_ipv6_loopback(ip):
			public_ipv6s.append(ip)

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

func is_ipv4_local(ip: String) -> bool:
	return (
		ip.begins_with("10.") or
		is_in_ipv4_range(ip, "172.", 16, 31) or
		ip.begins_with("192.168.")
	)

func is_ipv6_local(ip: String) -> bool:
	return ip.begins_with("fe80:") or ip.begins_with("fd00:")

func is_ipv4_loopback(ip: String) -> bool: 
	return ip.begins_with("127.")

func is_ipv6_loopback(ip: String) -> bool:
	return ip == "0:0:0:0:0:0:0:1"

func is_in_ipv4_range(ip: String, prefix: String, range_start: int, range_end: int) -> bool:
	for i in range(range_start, range_end + 1):
		if ip.begins_with(prefix + str(i) + ".") or ip == prefix + str(i):
			return true
	return false

func get_ips(type: AddressType) -> Array[String]:
	match type:
		AddressType.LOCAL_IPV4:
			return local_ipv4s
		AddressType.LOCAL_IPV6:
			return local_ipv6s
		AddressType.PUBLIC_IPV4:
			return public_ipv4s
		AddressType.PUBLIC_IPV6:
			return public_ipv6s
	return []

func get_best_type() -> AddressType:
	if public_ipv4s.size() > 0:
		return AddressType.PUBLIC_IPV4
	if public_ipv6s.size() > 0:
		return AddressType.PUBLIC_IPV6
	if local_ipv4s.size() > 0:
		return AddressType.LOCAL_IPV4
	if local_ipv6s.size() > 0:
		return AddressType.LOCAL_IPV6
		
	return AddressType.LOCAL_IPV4
