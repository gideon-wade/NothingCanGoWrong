class_name Dispenser extends Node3D

signal opening

@export var conical_flask_name_dispensed : String
#@onready var button: Node3D = $DispenserButton/ButtonCollisionShape
@onready var closet: Node3D = $closet
@onready var door : Node3D = $closet/Plane
var is_open := false
@onready var original_value = door.global_position
const OBJECT_OUTLINER = preload("res://models/textures/object_outliner.tres")
const CONICAL_FLASK = preload("res://src/objects/conical_flask/conical_flask.tscn")

const MAX_FLASKS := 2

func spawn_conical_flask() -> void:
	#door.global_position.y = door.global_position.y +1.0
	if is_full():
		print("dispenser is full")
		return
	var number_of_flasks = 0
	for child in get_parent().get_children():
		if child is ConicalFlask and child.substance_name == conical_flask_name_dispensed:
			number_of_flasks += 1
	if number_of_flasks >= MAX_FLASKS:
		return
	
	var is_open = true
	var tween = create_tween()
	tween.tween_property(door, "global_position",Vector3(original_value.x,original_value.y + 1.0, original_value.z) ,0.3)
	tween.set_trans(Tween.TRANS_QUAD)
	opening.emit()
	var flask = CONICAL_FLASK.instantiate()
	flask.substance_name = conical_flask_name_dispensed
	flask.color = GameMaster.colors[flask.substance_name]
	get_parent().add_child(flask)
	flask.position = $Marker3D.global_position


func is_full()-> bool:
	for body in $Area3D.get_overlapping_bodies():
		if body is GlassCol:
			return true
	return false
func _on_area_3d_body_entered(body):
	print("enter", body)


func _on_area_3d_body_exited(body):
	print("exiting : ", body)
	if not body is GlassCol:
		return
	var tween = create_tween()
	tween.tween_property(door, "global_position",Vector3(original_value.x,original_value.y, original_value.z) ,0.3)
