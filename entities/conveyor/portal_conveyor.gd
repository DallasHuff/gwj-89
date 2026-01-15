class_name PortalConveyor
extends Node3D

@export var transport_time := 0.7

var trash_type_queue := []
var time_stamp_queue := []

var transport_timer : Timer
var transport_timer_repeat_count := 0

var spawn_bounds_width := 0.3

@onready var exit_marker := %ExitMarker
@onready var trash_scene := preload("uid://b6pgrrfecfoqx")

func _ready() -> void:
	transport_timer = Timer.new()
	add_child(transport_timer)
	transport_timer.wait_time = transport_time
	transport_timer.one_shot = true
	transport_timer.timeout.connect(_pop_trash)

func _pop_trash() -> void:
	assert(len(trash_type_queue) > 0, "tried to pop trash when queue empty")
	
	transport_timer_repeat_count -= 1

	var curr_type : Trash.TrashType = trash_type_queue.pop_front()

	var random_pos_offset := Vector3.ZERO

	random_pos_offset.x += randf_range(-spawn_bounds_width, spawn_bounds_width)
	random_pos_offset.z += randf_range(-spawn_bounds_width, spawn_bounds_width)

	var t: Trash = trash_scene.instantiate()
	get_tree().root.add_child(t)
	t.trash_type = curr_type
	t.global_position = exit_marker.global_position + random_pos_offset

	if transport_timer_repeat_count > 0:
		transport_timer.start()


func _on_area_3d_body_entered(body: Node3D) -> void:
	if not body is Trash: 
		return
	body = body as Trash

	trash_type_queue.append(body.trash_type)
	body.free()

	transport_timer_repeat_count += 1
	transport_timer.start()
