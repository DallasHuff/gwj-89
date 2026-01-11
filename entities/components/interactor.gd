class_name Interactor
extends Area3D

const TRASH_GAP := Vector3(0, 0.3, 0)

var trash: Array[Trash] = []

@onready var hold_spot: Marker3D = $HoldSpotMarker
@onready var drop_spot: Marker3D = $DropSpotMarker


func _physics_process(_delta: float) -> void:
	if Input.is_action_pressed("pickup"):
		pickup()
	elif Input.is_action_just_pressed("putdown"):
		putdown()


func pickup() -> void:
	var bodies := get_overlapping_bodies()
	for i in range(bodies.size()):
		var body := bodies[i]
		if body is Trash and body not in trash:
			trash.append(body)
			body.global_position = hold_spot.global_position + (TRASH_GAP * trash.size())
			body.freeze = true
			body.reparent(self)


func putdown() -> void:
	if trash.size() < 1:
		return
	var t: Trash = trash.pop_front()
	t.reparent(get_tree().root)
	t.global_position = drop_spot.global_position
	t.freeze = false

	for i in range(trash.size()):
		trash[i].global_position = hold_spot.global_position + (TRASH_GAP * i)
