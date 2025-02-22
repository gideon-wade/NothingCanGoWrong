extends Node3D

@onready var door : Node3D = $scifi_door/Door
# Called when the node enters the scene tree for the first time.
func _ready():
	GameMaster.drain_poured.connect(open_door)


func open_door(body):
	var tween := create_tween()
	tween.tween_property(door, "global_position",Vector3(door.global_position.x,door.global_position.y - 5.0, door.global_position.z) ,3)
	tween.set_trans(Tween.TRANS_QUAD)
