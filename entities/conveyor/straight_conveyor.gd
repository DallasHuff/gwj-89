@tool
class_name StraightConveyor
extends Node3D

@export var conveyor_speed := 1.5

@export var enable_left_bumper := true
@export var enable_right_bumper := true
@export var enable_rear_bumper := false

@onready var belt_mover := %BeltMover

@onready var bumper_left := %BumperLeft
@onready var bumper_right := %BumperRight
@onready var bumper_rear := %BumperRear

func _ready() -> void:
	update_bumper()

func update_bumper() -> void:
	var new_vel := global_transform.basis.z * conveyor_speed
	belt_mover.set_constant_linear_velocity(new_vel)

	if not enable_left_bumper:
		bumper_left.free()
	
	if not enable_right_bumper:
		bumper_right.free()
	
	if not enable_rear_bumper:
		bumper_rear.free()
	else:
		bumper_rear.visible = true
