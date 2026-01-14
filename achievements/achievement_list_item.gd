class_name AchievementListItem
extends HBoxContainer

var achievement: Achievement

@onready var checkbox: CheckBox = %CheckBox
@onready var label: Label = %Label


func setup(a: Achievement) -> void:
	achievement = a
	label.text = achievement.display_name
	AchievementTracker.achieved.connect(_on_achieved)


func _on_achieved(a: Achievement) -> void:
	if a == achievement:
		checkbox.button_pressed = true
