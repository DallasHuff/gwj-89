class_name Interactor
extends Node3D

const TRASH_GAP := Vector3(0, 0.3, 0)

@export var inventory_size: int
@export var player_camera: PlayerCamera

var trash: Array[Trash] = []

@onready var hold_spot: Marker3D = $HoldSpotMarker
@onready var drop_spot: Marker3D = $DropSpotMarker
@onready var drop_offset := Vector3(0.0, 0.5, 0.0)
@onready var grab_marker: Marker3D = $GrabMarker
@onready var grab_area: Area3D = $GrabMarker/GrabArea


func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("pickup"):
		pickup()
	elif Input.is_action_just_pressed("putdown"):
		putdown()


func pickup() -> void:

	# move grab area
	assert(is_instance_valid(player_camera))
	grab_marker.global_position = player_camera.mouse_position + Vector3(0, 1.0, 0)

	var bodies := grab_area.get_overlapping_bodies()
	var closest_trash: Trash = null
	var min_dist := INF
	for i in range(bodies.size()):
		if trash.size() >= inventory_size:
			break
		var body := bodies[i]
		if body is Trash and body not in trash:

			var dist_to_player := body.position.distance_to(grab_marker.position)
			if min_dist > dist_to_player:
				min_dist = dist_to_player
				closest_trash = body as Trash

	if closest_trash != null:
		trash.append(closest_trash)
		closest_trash.global_position = hold_spot.global_position + (TRASH_GAP * trash.size())
		closest_trash.freeze = true
		closest_trash.pickup_sfx.play()
		closest_trash.reparent(self)
	if trash.size() >= inventory_size:
		AchievementTracker.achieve("Loaded Up")



func putdown() -> void:

	# move drop spot
	assert(is_instance_valid(player_camera))
	drop_spot.global_position = player_camera.mouse_position + drop_offset

	if trash.size() < 1:
		return
	var t: Trash = trash.pop_front()
	t.reparent(get_tree().root)
	t.global_position = drop_spot.global_position
	t.freeze = false

	for i in range(trash.size()):
		trash[i].global_position = hold_spot.global_position + (TRASH_GAP * i)
