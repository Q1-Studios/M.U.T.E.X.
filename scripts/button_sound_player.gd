extends Node

@onready var button: Button = $".."

@onready var focus_sound: AudioStreamPlayer = $FocusSound
@onready var click_sound: AudioStreamPlayer = $ClickSound

func _ready() -> void:
	button.focus_entered.connect(_on_focus)
	button.pressed.connect(_on_pressed)

func _on_focus() -> void:
	if button.is_visible_in_tree():
		focus_sound.play()

func _on_pressed() -> void:
	if button.is_visible_in_tree():
		click_sound.play()
