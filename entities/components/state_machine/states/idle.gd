class_name IdleState
extends State

@export var animation_player: AnimationPlayer

var idle_anims: Array[String] = ["idle_1", "idle_2"];
var idle: String = idle_anims[0];

func enter() -> void:
	#while(true):
	idle = idle_anims.pick_random();
	animation_player.play(idle)
	await animation_player.animation_finished
	transition_requested.emit("idle")

func physics_update(_delta: float) -> void:
	var input_dir := Input.get_vector("left", "right", "up", "down")
	if input_dir.length() >= 0.1:
		transition_requested.emit("run")
	
	# interact
	if Input.is_action_just_pressed("pickup") or Input.is_action_just_pressed("putdown"):
		transition_requested.emit("interact")
		


#func _on_animation_finished(anim_name: String) -> void:
	#if anim_name == idle:
		#transition_requested.emit("idle") 
