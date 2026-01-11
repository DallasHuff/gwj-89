extends Node

const PATH := "res://achievements"

@export var achievement_list: Array[Achievement] = []

var already_achieved: Array[String] = []
var achievement_queue: Array[Achievement] = []
var currently_achieving := false

@onready var panel: PanelContainer = %AchievementPanel
@onready var icon: TextureRect = %AchievementIcon
@onready var name_label: RichTextLabel = %AchievementName
@onready var desc_label: RichTextLabel = %AchievementDescription


func _ready() -> void:
	get_tree().create_timer(2).timeout.connect(func()->void: achieve("Logged In!"))


func _process(_delta: float) -> void:
	if achievement_queue.size() > 0 and not currently_achieving:
		_play_next_animation()


func achieve(achievement_name: String) -> void:
	if achievement_name in already_achieved:
		return
	var a: Achievement = null
	for achievement in achievement_list:
		if achievement.display_name == achievement_name:
			a = achievement
			break
	if a == null:
		push_warning("achievement not implemented ", achievement_name)
		return
	already_achieved.append(achievement_name)
	achievement_queue.append(a)


func _play_next_animation() -> void:
	if not achievement_queue.size() > 0:
		push_warning("trying to play animation but no achievements in queue")
		return
	currently_achieving = true
	var ach: Achievement = achievement_queue.pop_front()
	name_label.text = ach.display_name
	desc_label.text = ach.description
	icon.texture = ach.icon

	var tween := create_tween()
	tween.tween_property(panel, "anchor_top", 0.03, 0.5)
	tween.parallel().tween_property(panel, "anchor_bottom", 0.23, 0.5)
	tween.chain().tween_property(panel, "anchor_top", -0.23, 0.5).set_delay(4)
	tween.parallel().tween_property(panel, "anchor_bottom", -0.03, 0.5).set_delay(4)
	tween.chain().tween_callback(func() -> void: currently_achieving = false).set_delay(1)
