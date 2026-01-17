extends Node3D

@onready var physical_bone: PhysicalBoneSimulator3D = %PhysicalBoneSimulator3D
@onready var skeleton: Skeleton3D = $Rat1_rund/Rat1_Run/Skeleton3D
@onready var spine: PhysicalBone3D = $"Rat1_rund/Rat1_Run/Skeleton3D/PhysicalBoneSimulator3D/Physical Bone mixamorig_Spine1"


func _ready() -> void:
	get_tree().create_timer(0.5).timeout.connect(physical_bone.physical_bones_start_simulation)


func _physics_process(_delta: float) -> void:
	skeleton.global_transform = global_transform
