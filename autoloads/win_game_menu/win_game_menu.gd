extends CanvasLayer

@onready var continue_button: Button = %ContinueButton

func _ready() -> void:
	continue_button.pressed.connect(_on_continue_button_pressed)

func win() -> void:
	get_tree().paused = true
	show()

func _on_continue_button_pressed() -> void:
	get_tree().paused = false
	hide()
