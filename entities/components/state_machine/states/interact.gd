class_name InteractState
extends State

@export var animation_player: AnimationPlayer


func enter() -> void:
	animation_player.play("interact")
	animation_player.animation_finished.connect(_on_anim_finished)


func _on_anim_finished(anim_name: StringName) -> void:
	if anim_name == "interact":
		transition_requested.emit("idle")
		animation_player.animation_finished.disconnect(_on_anim_finished)
