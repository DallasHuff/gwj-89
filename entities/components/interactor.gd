class_name Interactor
extends Area3D

const TRASH_GAP := Vector3(0, 0.3, 0)

var trash: Array[Trash] = []

@onready var hold_spot: Marker3D = $HoldSpotMarker


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pickup"):
		pickup()
	elif event.is_action_pressed("putdown"):
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
	for t in trash:
		t.reparent(get_tree().root)
		t.freeze = false
	trash.clear()
