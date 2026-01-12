class_name Interactor
extends Node3D

const TRASH_GAP := Vector3(0, 0.3, 0)

@export var inventory_size: int
@export var player_camera: PlayerCamera

var trash: Array[Trash] = []

@onready var hold_spot: Marker3D = $HoldSpotMarker
@onready var drop_spot: Marker3D = $DropSpotMarker
@onready var drop_offset := Vector3(0.0, 0.5, 0.0)
@onready var grab_area: Area3D = $GrabArea


func _physics_process(_delta: float) -> void:
	if Input.is_action_pressed("pickup"):
		pickup()
	elif Input.is_action_just_pressed("putdown"):
		putdown()


func pickup() -> void:

	# move grab area
	assert(is_instance_valid(player_camera))
	grab_area.global_position = player_camera.mouse_position

	var bodies := grab_area.get_overlapping_bodies()
	for i in range(bodies.size()):
		if trash.size() >= inventory_size:
			break
		var body := bodies[i]
		if body is Trash and body not in trash:
			body = body as Trash
			trash.append(body)
			body.global_position = hold_spot.global_position + (TRASH_GAP * trash.size())
			body.freeze = true
			body.pickup_sfx.play()
			body.reparent(self)
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
