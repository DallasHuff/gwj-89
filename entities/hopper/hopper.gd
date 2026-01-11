class_name Hopper
extends Node3D

@onready var zone := %Zone
@onready var display := %Display
@onready var damage_display := %DamageDisplay

@export var processed_count := 0
@export var target_count := 10

@export var wanted_trash_type := Trash.TrashType.PAPER

@export var damage_amount := 12
@export var health := 100

func _on_zone_body_entered(body: Node3D) -> void:
	if not body is Trash:
		return
	
	var t: Trash = body
	var got_trash_type := t.trash_type
	t.queue_free()

	if got_trash_type != wanted_trash_type:
		health -= damage_amount
		damage_display.text = str(health) + "%"
		return

	processed_count += 1

	display.text = str(processed_count)

	if processed_count >= target_count:
		print("TARGET MET")
		# AchievementTracker.achieve(AchievementTracker.AchName.TARGET_MET)
