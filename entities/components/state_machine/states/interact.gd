class_name InteractState
extends State

@export var animation_player: AnimationPlayer
@export var player_camera: PlayerCamera
@export var character: CharacterBody3D

func enter() -> void:
	animation_player.play("interact")
	animation_player.animation_finished.connect(_on_anim_finished)
	animation_player.speed_scale = 10.0

func physics_update(delta: float) -> void:
	assert(is_instance_valid(player_camera))
	look_at_smooth(player_camera.mouse_position, delta)

func _on_anim_finished(anim_name: StringName) -> void:
	if anim_name == "interact":
		animation_player.speed_scale = 1.0
		transition_requested.emit("idle")
		animation_player.animation_finished.disconnect(_on_anim_finished)

func look_at_smooth(target: Vector3, delta: float, speed := 22.0) -> void:
	assert(is_instance_valid(character))

	var dir := target - character.global_position
	dir.y = 0.0

	if dir.length_squared() < 0.0001:
		return

	dir = dir.normalized()

	var target_yaw := atan2(-dir.x, -dir.z)
	character.rotation.y = lerp_angle(character.rotation.y, target_yaw, delta * speed)
