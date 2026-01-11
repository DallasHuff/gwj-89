extends Node3D

@export var rotation_speed := 2.0 # Rads per second

func _process(delta: float) -> void:
	rotate_y(rotation_speed * delta)
	
