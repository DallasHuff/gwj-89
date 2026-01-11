class_name Spawner
extends Node3D

@export var trash_scene: PackedScene = preload("res://entities/trash/trash.tscn")

var spawn_bounds_width := 0.3

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("debug1"):
		print("debug1")
		spawn_trash()

func spawn_trash() -> void:

	var random_pos_offset := Vector3.ZERO

	random_pos_offset.x += randf_range(-spawn_bounds_width, spawn_bounds_width)
	random_pos_offset.z += randf_range(-spawn_bounds_width, spawn_bounds_width)

	var t : Trash = trash_scene.instantiate()
	t.trash_type = Trash.METAL
	get_tree().root.add_child(t)
	t.global_position = global_position + random_pos_offset
