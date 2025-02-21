class_name Dispenser extends Node3D

@export var conical_flask_name_dispensed : String
@onready var button: Node3D = $DispenserButton/CollisionShape3D/button
@onready var closet: Node3D = $DinspenserBox/CollisionShape3D/closet

const OBJECT_OUTLINER = preload("res://models/textures/object_outliner.tres")
const CONICAL_FLASK = preload("res://src/objects/conical_flask/conical_flask.tscn")

func spawn_conical_flask() -> void:
	var number_of_flasks = 0
	for child in get_parent().get_children():
		if child is ConicalFlask and child.substance_name == conical_flask_name_dispensed:
			number_of_flasks += 1
	if number_of_flasks > 1:
		return
	var flask = CONICAL_FLASK.instantiate()
	flask.substance_name = conical_flask_name_dispensed
	flask.color = GameMaster.colors[flask.substance_name]
	get_parent().add_child(flask)
	flask.position = global_transform * Vector3(3, 0, 0)
