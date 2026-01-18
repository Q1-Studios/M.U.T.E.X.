extends Control

@export var start_overlay: Panel
@export var main_menu_layer: Panel
@export var init_focus_btn: Button

func _on_zoomin():
	main_menu_layer.show()
	start_overlay.hide()
	init_focus_btn.grab_focus()

signal zoomout

func _zoomout():
	zoomout.emit()


func _on_start_pressed() -> void:
	_zoomout()
