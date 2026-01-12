class_name RunState
extends State

@export var character: CharacterBody3D
@export var anim_player: AnimationPlayer
@export var movement_component: MovementComponent
@export var rotation_speed := 10.0

func enter() -> void:
	if not movement_component:
		push_error("run state not setup. attached to " + get_parent().name)
	anim_player.play("run")


func physics_update(delta: float) -> void:
	var input_dir := Input.get_vector("left", "right", "up", "down")
	if input_dir.length() <= 0.05:
		movement_component.direction = Vector3.ZERO
		transition_requested.emit("idle")
		return
	else:
		transition_requested.emit("run")  # Keep looping anim if still running.
	movement_component.direction = Vector3(input_dir.x, 0, input_dir.y).normalized()

	# rotate
	var target_angle := atan2(movement_component.direction.x, movement_component.direction.z) + PI
	character.rotation.y = lerp_angle(character.rotation.y, target_angle, rotation_speed * delta)

	# interact
	if Input.is_action_just_pressed("pickup"):
		movement_component.direction = Vector3.ZERO
		transition_requested.emit("interact")
