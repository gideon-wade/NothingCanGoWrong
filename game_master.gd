extends Node

var main_scene

signal conical_changed(color_change : String)

func new_substance_color(hexcode : String) -> void:
	conical_changed.emit(hexcode)

func task_complete(id : int) -> void:
	main_scene.task_complete(id)
	
