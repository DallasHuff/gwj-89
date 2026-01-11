class_name Hopper
extends Node3D

@onready var zone := %Zone
@onready var display := %Display

@export var processed_count := 0
@export var target_count := 10

func _on_zone_body_entered(body: Node3D) -> void:
    if not body is Trash:
        return
    
    var t: Trash = body
    t.queue_free()

    processed_count += 1

    display.text = str(processed_count)

    if processed_count >= target_count:
        print("TARGET MET")
        # AchievementTracker.achieve(AchievementTracker.AchName.TARGET_MET)
