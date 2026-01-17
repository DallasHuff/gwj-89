class_name PortalConveyor
extends Node3D

@export var transport_time := 0.7

var spawn_bounds_width := 0.3

@onready var exit_marker := %ExitMarker

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is not Trash: 
		return
	body = body as Trash

	body.hide()
	body.global_position = Vector3(1000, 0, 0)

	get_tree().create_timer(transport_time).timeout.connect(move_trash.bind(body))

func move_trash(t: Trash) -> void:
	var random_pos_offset := Vector3.ZERO

	random_pos_offset.x += randf_range(-spawn_bounds_width, spawn_bounds_width)
	random_pos_offset.z += randf_range(-spawn_bounds_width, spawn_bounds_width)
	t.global_position = exit_marker.global_position + random_pos_offset
	t.show()
