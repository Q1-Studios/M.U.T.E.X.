extends Node

@onready var control: Control = $".."

@onready var focus_sound: AudioStreamPlayer = $FocusSound
@onready var click_sound: AudioStreamPlayer = $ClickSound

func _ready() -> void:
	control.focus_entered.connect(_on_focus)
	
	if control is Button:
		control.pressed.connect(_on_pressed)
	if control is LineEdit:
		control.text_submitted.connect(_on_text_submitted)

func _on_focus() -> void:
	focus_sound.play()

func _on_pressed() -> void:
	click_sound.play()

func _on_text_submitted(_new_text: String) -> void:
	click_sound.play()
