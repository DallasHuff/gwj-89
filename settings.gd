extends Node

var music_volume: float = 0.5
var sfx_volume: float = 0.5


func set_bus_volume(percent: float, bus: String) -> void:
	var bus_index: int = AudioServer.get_bus_index(bus)
	var db := convert_percentage_to_decibels(percent)
	AudioServer.set_bus_volume_db(bus_index, db)


func convert_percentage_to_decibels(percent: float) -> float:
	const _scale: float = 20.0
	const _divisor: float = 50.0
	return _scale * log(percent / _divisor) / log(10)
