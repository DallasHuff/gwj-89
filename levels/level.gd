class_name Level
extends Node3D

@onready var stream: AudioStream = preload("uid://3optvx3oyrm2")
@onready var player: Player = %Player
@onready var canvas: CanvasLayer = %LoadingScreen
@onready var warmup_spawner: Spawner = $WarmupSpawner
@onready var music: AudioStreamPlayer = $Music
var player_init_position: Vector3

func _ready() -> void:
	add_to_group("level")
	add_to_group("reset")
	music.stream = stream
	get_tree().create_timer(45).timeout.connect(_force_spawn_body)
	player_init_position = player.global_position
	# If running from editor, skip preloading particles
	if OS.has_feature("editor"):
		canvas.hide()
		_start_spawners()
		music.play()
		return

	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), true)

	_hopper_particle_toggle(true)

	await get_tree().process_frame


	await get_tree().process_frame
	await get_tree().process_frame

	_hopper_particle_toggle(false)

	await get_tree().create_timer(4).timeout
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), false)

	music.play()
	_start_spawners()

	canvas.hide()

func look_at_smooth(target: Vector3, delta: float, speed := 12.0) -> void:
	var dir := target - player.global_position
	dir.y = 0.0

	if dir.length_squared() < 0.0001:
		return

	dir = dir.normalized()

	var target_yaw := atan2(-dir.x, -dir.z)
	player.rotation.y = lerp_angle(player.rotation.y, target_yaw, delta * speed)

func _start_spawners() -> void:
	var spawners := get_tree().get_nodes_in_group("spawner")
	for s in spawners:
		if s is not Spawner:
			push_warning("wrong node in spawner group: ", s.name)
			continue
		(s as Spawner).start()

func _hopper_particle_toggle(emitting: bool) -> void:
	var hoppers := get_tree().get_nodes_in_group("hopper")
	for h in hoppers:
		if h is not Hopper:
			continue
		h = h as Hopper
		h.sparks.emitting = emitting
		h.smoke.emitting = emitting
		h.blue_sparks.emitting = emitting

func reset() -> void:
	player.position = player_init_position

func _force_spawn_body() -> void:
	var spawner: Spawner = get_tree().get_nodes_in_group("spawner").pick_random()
	spawner.spawn_specific(Trash.TrashType.BODY)

func _warmup_trash() -> void:
	var types: Array[Trash.TrashType] = [Trash.TrashType.BODY, Trash.TrashType.PAPER, Trash.TrashType.PLASTIC, Trash.TrashType.METAL, Trash.TrashType.GLASS]
	for spawner in get_tree().get_nodes_in_group("spawner"):
		for t in types:
			spawner.spawn_specific(t)
			warmup_spawner.spawn_specific(t)
