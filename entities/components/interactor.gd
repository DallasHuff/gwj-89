class_name Interactor
extends Node3D

const TRASH_GAP := Vector3(0, 0.4, 0)

@export var inventory_size: int
@export var player_camera: PlayerCamera
@export var character: Player
@export var max_grab_dist := 2.7
@export var ray_display_fade_timer := 0.1
@export var interact_delay_timer := 0.05
@export var max_global_grab_height := 2.4

var trash: Array[Trash] = []
var time_elapsed := 0.0

@onready var hold_spot: Marker3D = $HoldSpotMarker
@onready var drop_spot: Marker3D = $DropSpotMarker
@onready var drop_offset := Vector3(0.0, 0.5, 0.0)
@onready var grab_marker: Marker3D = $GrabMarker
@onready var grab_area: Area3D = $GrabMarker/GrabArea
var grab_offset := Vector3(0.0, 0.0, 0.0)
@onready var ray_display := %RayDisplay
var display_timer : Timer
@onready var head_bonker := $HeadCollider
@onready var start_head_bonker_height: float = head_bonker.position.y

func _ready() -> void:
	add_to_group("reset")
	display_timer = Timer.new()
	add_child(display_timer)
	display_timer.wait_time = ray_display_fade_timer
	display_timer.one_shot = true
	display_timer.timeout.connect(hide_ray_display)

func _physics_process(delta: float) -> void:
	time_elapsed += delta
	_sway_trash()
	if Input.is_action_just_pressed("pickup"):
		pickup()
	elif Input.is_action_just_pressed("putdown"):
		putdown()

func show_ray_display() -> void:
	ray_display.show()
	display_timer.start()

func hide_ray_display() -> void:
	ray_display.hide()

func pickup() -> void:

	# move grab area
	assert(is_instance_valid(player_camera))
	show_ray_display()
	var targ_pos := player_camera.mouse_position + grab_offset
	if targ_pos.distance_to(character.position) > max_grab_dist:
		targ_pos = character.position.move_toward(targ_pos, max_grab_dist)
	targ_pos.y = clamp(targ_pos.y, -INF, max_global_grab_height)
	grab_marker.global_position = targ_pos 

	await get_tree().create_timer(interact_delay_timer).timeout

	var bodies := grab_area.get_overlapping_bodies()
	var closest_trash: Trash = null
	var min_dist := INF
	for i in range(bodies.size()):
		if trash.size() >= inventory_size:
			break
		var body := bodies[i]
		if body is Trash and body not in trash:
			var dist_to_grab_spot := body.position.distance_to(player_camera.mouse_position)
			if min_dist > dist_to_grab_spot:
				min_dist = dist_to_grab_spot
				closest_trash = body as Trash

	if closest_trash != null:
		AchievementTracker.achieve("Left Click to Grab")
		trash.append(closest_trash)
		closest_trash.global_position = hold_spot.global_position + (TRASH_GAP * trash.size())
		closest_trash.freeze = true
		closest_trash.pickup_sfx.play()
		closest_trash.reparent(self)
		closest_trash.top_level = true
	if trash.size() >= inventory_size:
		AchievementTracker.achieve("Loaded Up")

	update_head_height()

func putdown() -> void:

	# move drop spot
	assert(is_instance_valid(player_camera))
	show_ray_display()
	var targ_pos := player_camera.mouse_position + grab_offset
	if targ_pos.distance_to(character.position) > max_grab_dist:
		targ_pos = character.position.move_toward(targ_pos, max_grab_dist)
	
	targ_pos.y = clamp(targ_pos.y, -INF, max_global_grab_height)
	drop_spot.global_position = targ_pos
	# only doing this to update the ray display location
	grab_marker.global_position = targ_pos

	await get_tree().create_timer(interact_delay_timer).timeout

	if trash.size() < 1:
		return
	AchievementTracker.achieve("Right Click to Drop")
	var t: Trash = trash.pop_front()
	t.reparent(get_tree().root)
	t.global_position = drop_spot.global_position + Vector3(0, 0.5, 0)
	t.freeze = false
	t.top_level = false

	for i in range(trash.size()):
		trash[i].global_position = hold_spot.global_position + (TRASH_GAP * i)
	
	update_head_height()

func _sway_trash() -> void:
	# These variables are inverted. Higher numbers means lower speed / size
	var sway_speed := 1.5
	var sway_size := 100.0
	for i in range(trash.size()):
		var random_sway := Vector3((cos(time_elapsed/sway_speed) * sin(time_elapsed/sway_speed))/sway_size, 0, (sin(time_elapsed/sway_speed) * sin(time_elapsed/sway_speed))/sway_size)
		if i > 0:
			trash[i].global_position = lerp(trash[i].global_position, trash[i-1].global_position + TRASH_GAP + random_sway, 0.8)
		else:
			trash[i].global_position = lerp(trash[i].global_position, hold_spot.global_position, 0.8)


func _on_head_collider_body_entered(body: Node3D) -> void:
	var parent := body.get_parent()
	if not parent:
		return
	if not parent is StraightConveyor:
		return
	
	# drop all items
	for i in range(trash.size()):
		var t: Trash = trash.pop_back()
		var curr_pos := t.global_position
		t.reparent(get_tree().root)
		t.global_position = curr_pos
		t.freeze = false
		t.top_level = false

	AchievementTracker.achieve("Head Banger")

	update_head_height()

func update_head_height() -> void:
	var offset_height := trash.size() * TRASH_GAP.y
	head_bonker.position.y = offset_height + start_head_bonker_height

func reset() -> void:
	for i in range(trash.size()):
		var t: Trash = trash.pop_back()
		t.queue_free()
