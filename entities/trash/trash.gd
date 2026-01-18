class_name Trash
extends RigidBody3D

enum TrashType {
	METAL,
	GLASS,
	PLASTIC,
	PAPER,
	BODY,
}

const SFX_SPEED_THRESHOLD := 3

@export var type_to_data: Dictionary[TrashType, TrashData] = {}

var trash_type: TrashType = TrashType.PAPER : set = _set_trash_type
var cached_velocity := Vector3.ZERO
var previous_velocity := Vector3.ZERO

@onready var dropped_sfx: AudioStreamPlayer3D = %DroppedSFX
@onready var pickup_sfx: AudioStreamPlayer3D = %PickupSFX


func _ready() -> void:
	dropped_sfx.pitch_scale *= randf_range(0.95, 1.05)
	pickup_sfx.pitch_scale *= randf_range(0.95, 1.05)
	body_entered.connect(_on_body_entered)


func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	cached_velocity = previous_velocity
	previous_velocity = state.linear_velocity


func _set_trash_type(value: TrashType) -> void:
	var was_null := false
	if value == null:
		was_null = true
		value = TrashType.PAPER
	trash_type = value
	if not type_to_data.has(value):
		push_warning("Trash dic not set up for ", value)
		return
	var td := type_to_data[value]
	if not was_null:
		var model_scene: PackedScene = td.model_list.pick_random()
		var model: Node3D = model_scene.instantiate()
		add_child(model)
	dropped_sfx.stream = td.dropped_sfx
	pickup_sfx.stream = td.pickup_sfx


func _on_body_entered(_body: Node) -> void:
	if dropped_sfx.playing:
		return
	if abs(cached_velocity.y) > SFX_SPEED_THRESHOLD:
		dropped_sfx.play()
