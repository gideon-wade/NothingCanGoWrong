class_name Task extends Object
var description : String
var complete : bool = false
var goalHexCode : String
var id : int
var steps = []

func _init(_description : String, _goalHexCode : String, _id : int) -> void:
	description = _description
	goalHexCode = _goalHexCode
	id = _id
	GameMaster.conical_changed.connect(_update_task)

func _update_task(hexcode : String) -> void:
	if goalHexCode == hexcode:
		complete = true
		GameMaster.task_complete(id)
