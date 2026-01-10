class_name StraightConveyor
extends StaticBody3D

@export var conveyor_speed := 1.5

func _ready() -> void:
	var new_vel := global_transform.basis.z * conveyor_speed
	set_constant_linear_velocity(new_vel)
