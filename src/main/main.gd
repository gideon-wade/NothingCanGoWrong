extends Node3D
@onready var task_giver: TaskGiver = $TaskGiver
var clip_board_scene := preload("res://src/objects/clip_board/clip_board.tscn")
var clipboards : Dictionary
func _ready() -> void:
	var i = 0
	for task in task_giver.tasks:
		var scene = clip_board_scene.instantiate()
		self.add_child(scene)
		clipboards[task.id] = scene
		scene.position = Vector3(9 + i, 0, -18)
		scene.rotation = Vector3(0, -PI/2, 0)
		scene.label.text = task.description
		i += 1
	GameMaster.main_scene = self

func task_complete(id : int) -> void:
	clipboards[id].complete_task()
