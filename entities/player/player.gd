class_name Player
extends CharacterBody3D

var gravity_multiplier := 60.0

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta * gravity_multiplier
