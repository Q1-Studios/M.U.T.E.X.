extends Node3D # Or Node2D

@export var player_scene: PackedScene
@export var enemy_scene: PackedScene 
@export var missile_scene: PackedScene
@onready var enemySpawner: MultiplayerSpawner = $EnemySpawner

func _ready():
	# If this is the Host, spawn existing players (like yourself)
	if multiplayer.is_server():
		# 1 is always the ID of the server
		add_player(1) 
		
		# Connect to the signals from NetworkManager to handle future connections
		NetworkManager.player_connected.connect(add_player)
		NetworkManager.player_disconnected.connect(remove_player)
		
		# Spawn anyone who is already connected (rare edge case but good practice)
		for id in multiplayer.get_peers():
			add_player(id)

func add_player(peer_id, _player_info = {}):
	print("Adding Player to Scene " + str(peer_id))
	# Instantiate the player
	var player = player_scene.instantiate()
	
	# IMPORTANT: Set the name to the ID. 
	# The MultiplayerSpawner tracks nodes by name.
	player.name = str(peer_id) 
	
	# Add to the specific node you set in your MultiplayerSpawner "Spawn Path"
	$Players.add_child(player)
	connect_player_gun_signals(player)

func remove_player(peer_id):
	var player = $Players.get_node_or_null(str(peer_id))
	if player:
		player.queue_free()
		
func spawn_enemy(): 
	if not multiplayer.is_server():
		# Only host may spawn enemies
		return;
		
	var route_data = $PatrolRouteManager.get_random_route()

	
	var enemyTypes = [1,2]
	var enemy_instance = enemy_scene.instantiate();
	enemy_instance.name = "Enemy_%d%d" % [Time.get_ticks_usec(), randi()]
	$Enemies.add_child(enemy_instance)
	enemy_instance.set_multiplayer_authority(1)
	
	
	enemy_instance.initialize(enemyTypes.pick_random(), route_data["points"])
func _on_enemy_spawn_timer_timeout() -> void:
	spawn_enemy()
	
func spawn_bullet(isHost, missilePosition, missileTransform):
	# Security: Only Server spawns
	if not multiplayer.is_server(): return

	# 1. Instantiate
	var missile = missile_scene.instantiate()
	
	
	# 2. Force Unique Name (PREVENTS "Node Not Found" ERRORS)
	missile.name = "M_%d" % randi()

	# 4. Add Child (Networked)
	$Bullets.add_child(missile)
	missile.set_multiplayer_authority(1)
	
	# 5. Position & Rotation
	missile.global_position = missilePosition
	missile.global_transform.basis = missileTransform
	
	# 6. Setup Logic
	# owner.name == "1" checks if the shooter is the Host
	if missile.has_method("setup_server_logic"):
		missile.setup_server_logic(isHost)

func connect_player_gun_signals(player: Node):
	# Warte einen Frame damit die Gun sicher geladen ist
	await get_tree().process_frame
	
	# Finde die Gun im Player
	var gun1 = player.get_node_or_null("ModelContainer/LeftGun") 
	var gun2 = player.get_node_or_null("ModelContainer/RightGun")
	
	if gun1 and gun1.has_signal("spawnMissileClicked"):
		gun1.spawnMissileClicked.connect(spawn_bullet)
		
	if gun2 and gun2.has_signal("spawnMissileClicked"):
		gun2.spawnMissileClicked.connect(spawn_bullet)
