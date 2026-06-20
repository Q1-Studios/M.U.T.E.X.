extends Camera2D
class_name CameraController
signal zoom_in

@export var container: Node = null
@export var animation_player: AnimationPlayer
@export var subviewport: SubViewport
@export var move_speed_factor: float = 1.2
@export var zoom_speed_factor: float = 1
@onready var screen_center: Vector2 = get_viewport().get_visible_rect().size / 2

@export var mouse_hide_time: float = 3.0
@export var mouse_icon: CanvasItem

var target_zoom: Vector2 = Vector2(1, 1)
var time_until_snapback: float = 0

var time_since_mouse: float = 0
var last_frame_window_focus: bool = false

var allow_scene_change: bool = true

func _ready() -> void:
	position = screen_center
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

var zoomed = false
func _process(delta: float) -> void:
	# If the window was refocussed, hide mouse again
	if get_window().has_focus() and not last_frame_window_focus:
		hide_mouse()
	
	last_frame_window_focus = get_window().has_focus()
	
	if not get_window().has_focus():
		mouse_icon.hide()
	
	# Hide mouse when it is idle
	if time_since_mouse < mouse_hide_time and get_window().has_focus():
		time_since_mouse += delta
		if time_since_mouse >= mouse_hide_time:
			mouse_icon.hide()
			hide_mouse()
	
	if zoomed:
		var target_pos: Vector2 = Vector2(500, 250)
		var offset_vec: Vector2 = target_pos - position
		var distance: float = offset_vec.length()
		var speed: float = distance * move_speed_factor
		
		position = position.move_toward(target_pos, delta * speed)
	
	else:
		var mouse_pos: Vector2 = get_viewport().get_mouse_position()
		var offset_vec: Vector2 = mouse_pos - position
		var distance: float = offset_vec.length()
		
		var speed: float = distance * move_speed_factor
		if speed < 10:
			speed = 10
		
		position = position.move_toward(mouse_pos, delta * speed)
		
		if time_until_snapback > 0:
			time_until_snapback -= delta
			zoom = zoom.move_toward(target_zoom, delta * zoom_speed_factor)
			if time_until_snapback <= 0:
				zoom = Vector2(1, 1)
				time_until_snapback = 0
		
		if Input.is_anything_pressed():
			animation_player.play("zoom")
			zoomed = true

func zoom_and_snap_back(duration: float) -> void:
	target_zoom = Vector2(2, 2)
	time_until_snapback = duration

func hide_mouse() -> void:
	# Force refresh of mouse mode (workaround on macOS)
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN

func fettsack():
	zoom_in.emit()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion or event is InputEventMouseButton:
		mouse_icon.show()
		time_since_mouse = 0
	
	if event is InputEventJoypadButton or event is InputEventJoypadMotion or event is InputEventKey:
		mouse_icon.hide()
		hide_mouse()
	
	subviewport.push_input(event,false)

func _on_control_zoomout() -> void:
	animation_player.play("zoomback")

func set_allow_scene_change() -> void:
	# Must be called before changing scene
	# This prevents issues when playing the transition animation backwards
	# in case of a network error
	allow_scene_change = true

func change_scene_usw() -> void:
	if allow_scene_change:
		allow_scene_change = false
		var success: bool = false
		
		if container.iJoinedNotHosted:
			success = await NetworkManager.join_game(NetworkManager.LAST_SERVER_IP)
			if not success:
				display_network_error()
			return
		
		success = NetworkManager.host_game()
		if not success:
			display_network_error()
		ScoreManager.current_team_name = container.teamname

		# TODO container.hexkot
		# container.hexkot_secondary
		
		#TODO - add in correct place:
		#func game_over():
		#	if multiplayer.is_server():
		#	ScoreManager.save_current_run()

func display_network_error() -> void:
	animation_player.play_backwards("zoomback")
	animation_player.queue("network_error_menu_reset")
