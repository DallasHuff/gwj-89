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
var achievement_queue: Array[AchName] = []
var currently_achieving := false

@onready var panel: PanelContainer = %AchievementPanel
@onready var icon: TextureRect = %AchievementIcon
@onready var name_label: RichTextLabel = %AchievementName
@onready var desc_label: RichTextLabel = %AchievementDescription


func _ready() -> void:
	get_tree().create_timer(2).timeout.connect(func()->void: achieve(AchName.LOGGED_IN))


func _process(_delta: float) -> void:
	if achievement_queue.size() > 0 and not currently_achieving:
		_play_next_animation()


func achieve(ach_name: AchName) -> void:
	if ach_name in already_achieved:
		return
	if not achievement_dic.has(ach_name):
		push_warning("achievement not implemented ", ach_name)
		return
	already_achieved.append(ach_name)
	achievement_queue.append(ach_name)


func _play_next_animation() -> void:
	if not achievement_queue.size() > 0:
		push_warning("trying to play animation but no achievements in queue")
		return
	currently_achieving = true
	var ach := achievement_dic[achievement_queue.pop_front()]
	name_label.text = ach.display_name
	desc_label.text = ach.description
	icon.texture = ach.icon

	var tween := create_tween()
	tween.tween_property(panel, "anchor_top", 0, 0.5)
	tween.parallel().tween_property(panel, "anchor_bottom", 0.2, 0.5)
	tween.chain().tween_property(panel, "anchor_top", -0.2, 0.5).set_delay(4)
	tween.parallel().tween_property(panel, "anchor_bottom", 0, 0.5).set_delay(4)
	tween.chain().tween_callback(func() -> void: currently_achieving = false).set_delay(1)
