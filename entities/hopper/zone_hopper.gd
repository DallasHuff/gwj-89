class_name ZoneHopper
extends Node3D

@export_category("processing")
@export var processed_count := 0
@export var target_count := 10
@export var wanted_trash_type := Trash.TrashType.PAPER

@onready var zone := %Zone
@onready var display := %Display

func _on_zone_body_entered(body: Node3D) -> void:
    if not body is Trash:
        return
    
    var t := body as Trash
    var got_trash_type := t.trash_type

    if got_trash_type == wanted_trash_type:
        processed_count += 1

    display.text = "%03d" % processed_count

func _on_zone_body_exited(body: Node3D) -> void:
    if not body is Trash:
        return
    
    var t := body as Trash
    var got_trash_type := t.trash_type

    if got_trash_type == wanted_trash_type:
        processed_count -= 1
    
    display.text = "%03d" % processed_count
