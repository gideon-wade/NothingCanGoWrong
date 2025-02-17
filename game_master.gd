extends Node

signal conical_changed(color_change : String)

func new_substance_color(hexcode : String) -> void:
	conical_changed.emit(hexcode)
