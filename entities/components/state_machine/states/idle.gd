class_name IdleState
extends State

@export var animation_player: AnimationPlayer


func enter() -> void:
	animation_player.play("idle")


func physics_update(_delta: float) -> void:
	var input_dir := Input.get_vector("left", "right", "up", "down")
	if input_dir.length() >= 0.1:
		transition_requested.emit("run")
