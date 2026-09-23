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
		if is_ipv4(ip) and (ip.begins_with("10.") or ip.begins_with("172.16.") or ip.begins_with("192.168.")):
			local_ipv4s.append(ip)
		elif is_ipv4(ip) and ip != "127.0.0.1":
			public_ipv4s.append(ip)
		elif is_ipv6(ip) and (ip.begins_with("fe80:") or ip.begins_with("fd00:")) and ip != "fe80:0:0:0:0:0:0:1":
			local_ipv6s.append(ip)
		elif is_ipv6(ip) and ip != "0:0:0:0:0:0:0:1" and ip != "fe80:0:0:0:0:0:0:1":
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
