extends StaticBody3D

@onready var button: Node3D = $ButtonCollisionShape/button

const OBJECT_OUTLINER = preload("res://models/textures/object_outliner.tres")


func show_outline() -> void:
	button.get_node("Cylinder").material_overlay = OBJECT_OUTLINER

func remove_outline() -> void:
	button.get_node("Cylinder").material_overlay = null
