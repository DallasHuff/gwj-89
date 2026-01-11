class_name Interactor
extends Area3D

const TRASH_GAP := Vector3(0, 0.3, 0)

var trash: Array[Trash] = []

@onready var hold_spot: Marker3D = $HoldSpotMarker


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		if trash.size() < 1:
			pickup()
		else:
			putdown()


func _process(_delta: float) -> void:
	for i in range(trash.size()):
		var t := trash[i]
		t.global_position = hold_spot.global_position + (TRASH_GAP * i)


func pickup() -> void:
	var bodies := get_overlapping_bodies()
	for i in range(bodies.size()):
		var body := bodies[i]
		if body is Trash:
			print("trash")
			trash.append(body)
			body.global_position = hold_spot.global_position + (TRASH_GAP * i)
			body.freeze = true


func putdown() -> void:
	for t in trash:
		t.freeze = false
	trash.clear()
