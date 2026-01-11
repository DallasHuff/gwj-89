extends CanvasLayer

var music_volume: float = 50
var sfx_volume: float = 50

@onready var music_slider: HSlider = %MusicVolumeSlider
@onready var sfx_slider: HSlider = %SFXVolumeSlider


func _ready() -> void:
	hide()
	music_slider.value = music_volume
	sfx_slider.value = sfx_volume

	music_slider.value_changed.connect(set_bus_volume.bind("Music"))
	sfx_slider.value_changed.connect(set_bus_volume.bind("SFX"))


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


func set_bus_volume(percent: float, bus: String) -> void:
	var bus_index: int = AudioServer.get_bus_index(bus)
	var db := convert_percentage_to_decibels(percent)
	AudioServer.set_bus_volume_db(bus_index, db)


func convert_percentage_to_decibels(percent: float) -> float:
	const _scale: float = 20.0
	const _divisor: float = 50.0
	return _scale * log(percent / _divisor) / log(10)
