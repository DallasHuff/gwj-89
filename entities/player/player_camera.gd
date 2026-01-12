class_name PlayerCamera
extends Camera3D

@export var debug := false
@export var ray_display_fade_timer := 0.1
var mouse_position := Vector3.ZERO
@onready var player: Player = get_parent()

func _process(_delta: float) -> void:
	shoot_ray()

func _physics_process(_delta: float) -> void:
	global_position = lerp(global_position, player.global_position + Vector3(0, 9, 4), 0.1)

func shoot_ray() -> void:
	var mouse_pos := get_viewport().get_mouse_position()
	var ray_length := 1000
	var from := project_ray_origin(mouse_pos)
	var to := from + project_ray_normal(mouse_pos) * ray_length
	var space := get_world_3d().direct_space_state
	find_mouse_position(space, to, from)


func find_mouse_position(space: PhysicsDirectSpaceState3D, to: Vector3, from: Vector3) -> void:
	var ray_query := PhysicsRayQueryParameters3D.new()
	ray_query.collision_mask = 1 << 15
	ray_query.from = from
	ray_query.to = to
	var raycast_result := space.intersect_ray(ray_query)
	if raycast_result.has("position"):
		mouse_position = raycast_result["position"]
	elif debug:
		push_warning("no mouse position from camera")
