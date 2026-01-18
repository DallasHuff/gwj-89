class_name Hopper
extends Node3D

@export_category("processing")
@export var processed_count := 0
@export var target_count := 10
@export var wanted_trash_type := Trash.TrashType.PAPER
@export_category("durability")
@export var damage_amount := 12
@export var health := 100

var destroyed := false
var goal_met := false

@onready var zone := %Zone
@onready var display := %Display
@onready var damage_display := %DamageDisplay
@onready var smoke: CPUParticles3D = %SmokeParticles
@onready var sparks: CPUParticles3D = %SparkParticles
@onready var blue_sparks: CPUParticles3D = %BlueSparkParticles

func _ready() -> void:
	add_to_group("reset")

func _on_zone_body_entered(body: Node3D) -> void:
	if not body is Trash:
		return
	
	var t: Trash = body
	var got_trash_type := t.trash_type
	t.queue_free()

	if destroyed:
		return

	if got_trash_type != wanted_trash_type:
		health -= damage_amount
		damage_display.text = str(health) + "%"
		sparks.emitting = true
	else:
		processed_count += 1
		blue_sparks.emitting = true

	EventsBus.trash_grinded.emit(got_trash_type, got_trash_type == wanted_trash_type)

	if health <= 0:
		destroyed = true
		smoke.emitting = true
		EventsBus.hopper_destroyed.emit()

	# display.text = str(processed_count)
	display.text = "%03d" % processed_count

	if not goal_met and processed_count >= target_count:
		goal_met = true
		EventsBus.goal_met.emit(health)

func reset() -> void:
	smoke.emitting = false
	sparks.emitting = false
	blue_sparks.emitting = false
	health = 100
	destroyed = false
	processed_count = 0
	goal_met = false
	damage_display.text = str(health) + "%"
	display.text = "%03d" % processed_count
