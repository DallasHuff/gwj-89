class_name Spawner
extends Node3D

@export var trash_type := Trash.TrashType.PLASTIC
@export var spawn_timer_range_min := 3.0
@export var spawn_timer_range_max := 7.0
@export var spawn_timer_start_delay := 3.0

var spawn_bounds_width := 0.3
var spawn_timer: Timer

@onready var trash_scene := preload("uid://b6pgrrfecfoqx")

func _ready() -> void:
	spawn_timer = Timer.new()
	add_child(spawn_timer)
	spawn_timer.wait_time = spawn_timer_start_delay
	spawn_timer.one_shot = true
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)
	spawn_timer.start()

func _on_spawn_timer_timeout() -> void:
	spawn_trash()

	var rand_wait := randf_range(spawn_timer_range_min, spawn_timer_range_max)
	# print("waiting: ", rand_wait)
	spawn_timer.wait_time = rand_wait
	spawn_timer.start()


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("debug1"):
		print("debug1")
		spawn_trash()

func spawn_trash() -> void:
	var random_pos_offset := Vector3.ZERO

	random_pos_offset.x += randf_range(-spawn_bounds_width, spawn_bounds_width)
	random_pos_offset.z += randf_range(-spawn_bounds_width, spawn_bounds_width)

	var t: Trash = trash_scene.instantiate()
	get_tree().root.add_child(t)
	t.trash_type = trash_type
	t.global_position = global_position + random_pos_offset
