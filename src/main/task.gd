class_name Task extends Object
var description : String
var complete : bool = false
var substance_name : String
var id : int
var steps = []

func _init(_description : String, _substance_name : String, _id : int) -> void:
	description = _description
	substance_name = _substance_name
	id = _id
	GameMaster.conical_changed.connect(_update_task)

func _update_task(_substance_name : String) -> void:
	if substance_name == _substance_name:
		complete = true
		GameMaster.task_complete(id)
