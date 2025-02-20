class_name Dispenser extends Node3D

@onready var button: Node3D = $DispenserButton/CollisionShape3D/button
@onready var closet: Node3D = $DinspenserBox/CollisionShape3D/closet

const OBJECT_OUTLINER = preload("res://models/textures/object_outliner.tres")
