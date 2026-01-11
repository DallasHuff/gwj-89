class_name Level
extends Node3D

@onready var ray_cam: RayCamera = %RayCamera
@onready var player: Player = %Player


func _ready() -> void:
	ray_cam.rotation = Vector3(deg_to_rad(-50), 0, 0)


func _physics_process(delta: float) -> void:
	if ray_cam.mouse_position:
		var look_pos := Vector3(
			ray_cam.mouse_position.x,
			player.global_position.y,
			ray_cam.mouse_position.z
		)
		look_at_smooth(look_pos, delta)
	ray_cam.global_position = lerp(ray_cam.global_position, player.global_position + Vector3(0, 9, 4), 0.1)


func look_at_smooth(target: Vector3, delta: float, speed := 8.0) -> void:
	var dir := target - player.global_position
	dir.y = 0.0

	if dir.length_squared() < 0.0001:
		return

	dir = dir.normalized()

	var target_yaw := atan2(-dir.x, -dir.z)
	player.rotation.y = lerp_angle(player.rotation.y, target_yaw, delta * speed)
