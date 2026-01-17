extends CanvasLayer

@onready var master_slider: HSlider = %MasterVolumeSlider
@onready var master_label: Label = %MasterPercent
@onready var music_slider: HSlider = %MusicVolumeSlider
@onready var music_label: Label = %MusicPercent
@onready var sfx_slider: HSlider = %SFXVolumeSlider
@onready var sfx_label: Label = %SFXPercent
@onready var exit_button: Button = %ExitButton


func _ready() -> void:
	hide()

	master_slider.value_changed.connect(set_bus_volume.bind("Master").bind(master_label))
	music_slider.value_changed.connect(set_bus_volume.bind("Music").bind(music_label))
	sfx_slider.value_changed.connect(set_bus_volume.bind("SFX").bind(sfx_label))

	exit_button.pressed.connect(pause)


func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		pause()


func pause() -> void:
	if get_tree().paused:
		get_tree().paused = false
		hide()
	else:
		get_tree().paused = true
		show()


func set_bus_volume(percent: float, label: Label, bus: String) -> void:
	label.text = str(int(percent))
	var bus_index: int = AudioServer.get_bus_index(bus)
	var db := convert_percentage_to_decibels(percent)
	AudioServer.set_bus_volume_db(bus_index, db)


func convert_percentage_to_decibels(percent: float) -> float:
	const _scale: float = 20.0
	const _divisor: float = 50.0
	return _scale * log(percent / _divisor) / log(10)
