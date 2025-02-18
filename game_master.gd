extends Node


var recipies

var main_scene

signal conical_changed(color_change : String)
signal fail()

func new_substance_color(hexcode : String) -> void:
	conical_changed.emit(hexcode)

func task_complete(id : int) -> void:
	main_scene.task_complete(id)

func mix(color1: String, color2: String) -> void:
	if false:
		fail.emit()
