extends CanvasLayer

var labels: Array[Label]
var current_label: int = 0

@onready var l1: Label = $Label
@onready var l2: Label = $Label2
@onready var l3: Label = $Label3
@onready var l4: Label = $Label4
@onready var timer: Timer = $Timer


func _ready() -> void:
	labels = [l1, l2, l3, l4]
	timer.timeout.connect(_on_timer_timeout)


func _on_timer_timeout() -> void:
	labels[current_label].hide()
	current_label += 1
	if current_label >= labels.size():
		current_label = 0
	labels[current_label].show()
	print(current_label)
	