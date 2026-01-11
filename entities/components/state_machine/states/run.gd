class_name RunState
extends State

@export var character: CharacterBody3D
@export var anim_player: AnimationPlayer
@export var movement_component: MovementComponent


func enter() -> void:
	if not movement_component:
		push_error("run state not setup. attached to " + get_parent().name)
	anim_player.play("run")


func physics_update(_delta: float) -> void:
	var input_dir := Input.get_vector("left", "right", "up", "down")
	if input_dir.length() <= 0.05:
		movement_component.direction = Vector3.ZERO
		transition_requested.emit("idle")
		return
	else:
		transition_requested.emit("run")  # Keep looping if still running.
	movement_component.direction = Vector3(input_dir.x, 0, input_dir.y).normalized()

	# interact
	if Input.is_action_just_pressed("pickup"):
		movement_component.direction = Vector3.ZERO
		transition_requested.emit("interact")
