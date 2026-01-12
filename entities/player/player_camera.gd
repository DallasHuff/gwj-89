class_name RayCamera
extends Camera3D

@export var debug := false
@export var ray_display_fade_timer := 0.1
var mouse_position := Vector3.ZERO

@onready var ray_display := %RayDisplay
@onready var player := %Player

var display_timer : Timer

func _ready() -> void:
	display_timer = Timer.new()
	add_child(display_timer)
	display_timer.wait_time = ray_display_fade_timer
	display_timer.one_shot = true
	display_timer.timeout.connect(_hide_ray_display)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pickup"):
		shoot_ray()
		ray_display.global_position = mouse_position
		ray_display.show()
		display_timer.start()

func _physics_process(_delta: float) -> void:
	global_position = lerp(global_position, player.global_position + Vector3(0, 9, 4), 0.1)

func _hide_ray_display() -> void:
	ray_display.hide()

func shoot_ray() -> void:
	var mouse_pos := get_viewport().get_mouse_position()
	var ray_length := 1000
	var from := project_ray_origin(mouse_pos)
	var to := from + project_ray_normal(mouse_pos) * ray_length
	var space := get_world_3d().direct_space_state
	find_mouse_position(space, to, from)


func find_mouse_position(space: PhysicsDirectSpaceState3D, to: Vector3, from: Vector3) -> void:
	var ray_query := PhysicsRayQueryParameters3D.new()
	# ray_query.collision_mask = 1 << 15
	ray_query.collision_mask = 1
	ray_query.from = from
	ray_query.to = to
	var raycast_result := space.intersect_ray(ray_query)
	if raycast_result.has("position"):
		mouse_position = raycast_result["position"]
	elif debug:
		push_warning("no mouse position from camera")
