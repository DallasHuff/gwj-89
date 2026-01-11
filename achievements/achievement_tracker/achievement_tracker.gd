extends Node

enum AchName {
	LOGGED_IN,
	ATE_CHEESE,
	KILLED_WES,
	STOLE_THE_MOON,
}

const PATH := "res://achievements"

@export var achievement_dic: Dictionary[AchName, Achievement] = {}

var already_achieved: Array[AchName] = []

@onready var panel: PanelContainer = %AchievementPanel
@onready var icon: TextureRect = %AchievementIcon
@onready var name_label: RichTextLabel = %AchievementName
@onready var desc_label: RichTextLabel = %AchievementDescription


func _ready() -> void:
	get_tree().create_timer(2).timeout.connect(func()->void: achieve(AchName.LOGGED_IN))


func achieve(ach_name: AchName) -> void:
	if ach_name in already_achieved:
		return
	if not achievement_dic.has(ach_name):
		push_error("achievement not implemented ", ach_name)
		return
	already_achieved.append(ach_name)
	var ach := achievement_dic[ach_name]
	name_label.text = ach.display_name
	desc_label.text = ach.description
	icon.texture = ach.icon

	var tween := create_tween()
	tween.tween_property(panel, "anchor_top", 0, 0.5)
	tween.parallel().tween_property(panel, "anchor_bottom", 0.2, 0.5)
	tween.chain().tween_property(panel, "anchor_top", -0.2, 0.5).set_delay(4)
	tween.parallel().tween_property(panel, "anchor_bottom", 0, 0.5).set_delay(4)
