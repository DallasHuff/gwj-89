extends Node3D

@onready var physical_bone: PhysicalBoneSimulator3D = %PhysicalBoneSimulator3D


func _ready() -> void:
	get_tree().create_timer(0.5).timeout.connect(physical_bone.physical_bones_start_simulation)
