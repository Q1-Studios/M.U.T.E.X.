extends Control

func _on_zoomin():
	$Panel3.show()
	$Panel.hide()
	$Panel3/HostGameBTN.grab_focus()
