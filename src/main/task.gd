class_name Task extends Object
var description : String
var complete : bool = false
var goalHexCode : String

func _init(_description : String, _goalHexCode : String) -> void:
	description = _description
	goalHexCode = _goalHexCode
	GameMaster.conical_changed.connect(_update_task)

func _update_task(hexcode : String) -> void:
	if goalHexCode == hexcode:
		complete = true
		print("W")
	else:
		print("no shot")
