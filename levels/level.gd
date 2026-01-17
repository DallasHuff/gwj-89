class_name Level
extends Node3D

@onready var player: Player = %Player
@onready var canvas: CanvasLayer = %CanvasLayer

func _ready() -> void:
	# If running from editor, skip preloading particles
	if OS.has_feature("editor"):
		canvas.hide()
		_start_spawners()
		return

	_hopper_particle_toggle(true)

	await get_tree().process_frame
	await get_tree().process_frame

	_hopper_particle_toggle(false)

	await get_tree().create_timer(4).timeout
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
