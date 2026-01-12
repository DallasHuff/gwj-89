class_name InteractState
extends State

@export var animation_player: AnimationPlayer
# @export var ray_camera: RayCamera

func enter() -> void:
	animation_player.play("interact")
	animation_player.animation_finished.connect(_on_anim_finished)
	print("interact entered")

# func _physics_process(_delta: float) -> void:
# 	assert(is_instance_valid(ray_camera))


func _on_anim_finished(anim_name: StringName) -> void:
	print("interact finished")
	if anim_name == "interact":
		transition_requested.emit("idle")
		animation_player.animation_finished.disconnect(_on_anim_finished)
