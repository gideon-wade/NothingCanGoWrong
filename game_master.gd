extends Node

var interactable = [ConicalFlask, ClipBoard]

var recipies = {
	"Oceamid,Redamin": "Grass Juice",
	"Grass Juice,Apple Juice": "Cadrulium",
	"Cadrulium,Grass Juice": "Princiade",
	"Princiade,Oceamid": "Dracula's Blood",
	"Dracula's Blood,Apple Juice": "Laudle",
}

var colors = {
	"Oceamid": Vector3(0, 0, 1),
	"Redamin": Vector3(1, 0, 0),
	"Apple Juice": Vector3(1, 1, 0),
	"Grass Juice": Vector3(0, 1, 0),
	"Cadrulium": Vector3(128/256.0, 0, 128/256.0),
	"Princiade": Vector3(1, 100/256.0, 150/256.0),
	"Dracula's Blood": Vector3(150/256.0, 0, 0),
	"Laudle": Vector3(150/256.0, 1, 150/256.0),
}
var substance_glow = {
	"Oceamid": 0.45,
	"Redamin": 0.3,
	"Apple Juice": 0.1,
	"Grass Juice": 0.1,
	"Cadrulium": 0.6,
	"Princiade": 0.9,
	"Dracula's Blood": 0.2,
	"Laudle": 0.6,
}

var main_scene

signal conical_changed(color_change : String)
signal fail(fail_position : Vector3)

func new_substance_color(hexcode : String) -> void:
	conical_changed.emit(hexcode)

func task_complete(id : int) -> void:
	main_scene.task_complete(id)

func mix(substance1: String, substance2: String, flask: ConicalFlask, position : Vector3) -> void:
	var comb1 = recipies.get(substance1+","+substance2, "fail")
	var comb2 = recipies.get(substance2+","+substance1, "fail")
	var out = comb1 if comb1 != "fail" else comb2
	if out != "fail":
		flask.substance_name = out
		flask.color = colors[out]
		flask.set_color()
	else:
		fail.emit(position)
