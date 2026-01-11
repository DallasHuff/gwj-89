class_name Spawner
extends Node3D

@export var trash_scene: PackedScene = preload("res://entities/trash/trash.tscn")

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("debug1"):
		print("debug1")
		spawn_trash()

func spawn_trash() -> void:
	var t : Trash = trash_scene.instantiate()
	t.trash_type = Trash.METAL
	get_tree().root.add_child(t)
	t.global_position = global_position
