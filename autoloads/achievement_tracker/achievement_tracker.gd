extends Node

signal achieved(achievement: Achievement)

const PATH := "res://achievements"

@export var achievement_list: Array[Achievement] = []

var already_achieved: Array[String] = []
var achievement_queue: Array[Achievement] = []
var currently_achieving := false

# Variables tracking specific achievements
var trash_streak: int = 0

@onready var panel: PanelContainer = %AchievementPanel
@onready var icon: TextureRect = %AchievementIcon
@onready var name_label: RichTextLabel = %AchievementName
@onready var desc_label: RichTextLabel = %AchievementDescription
@onready var list_container: VBoxContainer = %AchievementListContainer
@onready var tooltip: Control = %Tooltip
@onready var tooltip_label: RichTextLabel = %TooltipLabel
@onready var achieved_sfx: AudioStreamPlayer = %AchievedSFX
@onready var ach_list_item_scene := preload("uid://cmgtsj8ljqgmc")


func _ready() -> void:
	for achievement in achievement_list:
		var list_item: AchievementListItem = ach_list_item_scene.instantiate()
		list_container.add_child(list_item)
		list_item.setup(achievement)
		list_item.mouse_entered.connect(_on_item_mouse_entered.bind(achievement).bind(list_item))
		list_item.mouse_exited.connect(_on_item_mouse_exited.bind(list_item))
	get_tree().create_timer(4).timeout.connect(achieve.bind("Logged In!"))
	EventsBus.trash_grinded.connect(_on_trash_grinded)
	EventsBus.hopper_destroyed.connect(_on_hopper_destroyed)
	EventsBus.goal_met.connect(_on_goal_met)
	tooltip.hide()


func _process(_delta: float) -> void:
	if achievement_queue.size() > 0 and not currently_achieving:
		_play_next_animation()


func achieve(achievement_name: String) -> void:
	achievement_name = achievement_name.to_lower()
	if achievement_name in already_achieved:
		return
	var a: Achievement = null
	for achievement in achievement_list:
		if achievement.display_name.to_lower() == achievement_name:
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

	achieved_sfx.pitch_scale = randf_range(0.95, 1.05)
	achieved_sfx.play()
	achieved.emit(ach)

	var tween := create_tween()
	tween.tween_property(panel, "anchor_top", 0.77, 0.5)
	tween.parallel().tween_property(panel, "anchor_bottom", 0.97, 0.5)
	tween.chain().tween_property(panel, "anchor_top", 1.03, 0.5).set_delay(4)
	tween.parallel().tween_property(panel, "anchor_bottom", 1.23, 0.5).set_delay(4)
	tween.chain().tween_callback(_animation_finished).set_delay(1)


func _animation_finished() -> void:
	currently_achieving = false
	if already_achieved.size() == achievement_list.size():
		WinGameMenu.win()


func _on_trash_grinded(_type: Trash.TrashType, correct_type: bool) -> void:
	if correct_type:
		trash_streak += 1
	else:
		trash_streak = 0

	if trash_streak >= 100:
		achieve("item streak")


func _on_hopper_destroyed() -> void:
	achieve("grinder down")


func _on_goal_met(_durability: int, type: Trash.TrashType) -> void:
	match type:
		Trash.TrashType.PLASTIC:
			achieve("saved the turtles")
		Trash.TrashType.GLASS:
			achieve("Wine Time")
		Trash.TrashType.METAL:
			achieve("Fed the Machine")
		Trash.TrashType.PAPER:
			achieve("Well-Read")


func _on_item_mouse_entered(list_item: AchievementListItem, a: Achievement) -> void:
	achieve("Hover Over Me!")
	list_item.modulate = Color.OLIVE
	tooltip.show()
	tooltip_label.text = a.description


func _on_item_mouse_exited(list_item: AchievementListItem) -> void:
	list_item.modulate = Color.WHITE
	tooltip.hide()
