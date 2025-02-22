extends Node

signal drain_poured(activate_chemical : String)

var explosion_scene := preload("res://explosion.tscn")
var interactable = [ConicalFlask, ClipBoard]

var recipies = {
	#Tutorail
	"Lime,Sepirium": "Cactus Water",
	"Lime,Cactus Water": "Apple Juice",
	#Lvl 1
	"Oceamid,Redamin": "Grass Juice",
	"Grass Juice,Apple Juice": "Cadrulium",
	"Cadrulium,Grass Juice": "Princiade",
	"Princiade,Oceamid": "Dracula's Blood",
	"Dracula's Blood,Apple Juice": "Laudle",
	#Lvl 2
	"Laudle,Liquid Stone": "Washing Powder",
	"Laudle,Orange Juice": "Cider",
	"Washing Powder,Cider": "Tonic",
	"Liquid Stone,Orange Juice": "Jam",
	"Tonic,Jam": "Water",
}

var colors = {
	#Tutorial
	"Lime": Vector3(0, 200/256, 1),
	"Sepirium": Vector3(240/256.0, 240/256.0, 240/256.0),
	"Cactus Water": Vector3(0, 100/256.0, 0),
	#Lvl 1
	"Oceamid": Vector3(0, 0, 1),
	"Redamin": Vector3(1, 0, 0),
	"Apple Juice": Vector3(1, 1, 0),
	"Grass Juice": Vector3(0, 1, 0),
	"Cadrulium": Vector3(128/256.0, 0, 128/256.0),
	"Princiade": Vector3(1, 100/256.0, 150/256.0),
	"Dracula's Blood": Vector3(150/256.0, 0, 0),
	"Laudle": Vector3(150/256.0, 1, 150/256.0),
	#Lvl 2
	"Liquid Stone": Vector3(0, 0, 0),
	"Orange Juice": Vector3(232/256.0, 100/256.0, 0),
	"Washing Powder": Vector3(140/256.0, 140/256.0, 140/256.0),
	"Cider": Vector3(75/256.0, 200/256.0, 0),
	"Tonic": Vector3(244/256.0, 252/256.0, 136/256.0),
	"Jam": Vector3(256/256.0, 80/256.0, 80/256.0),
	"Water": Vector3(80/256.0, 255/256.0, 256/256.0),
}
var substance_glow = {
	#Tutorial
	"Lime": 0.35,
	"Sepirium": 0.8,
	"Cactus Water": 0.1,
	#Lvl 1
	"Oceamid": 0.45,
	"Redamin": 0.3,
	"Apple Juice": 0.1,
	"Grass Juice": 0.1,
	"Cadrulium": 0.6,
	"Princiade": 0.9,
	"Dracula's Blood": 0.2,
	"Laudle": 0.6,
	#Lvl 2
	"Liquid Stone": 0.1,
	"Orange Juice": 0.1,
	"Washing Powder": 0.4,
	"Cider": 0.5,
	"Tonic": 0.3,
	"Jam": 0.2,
	"Water": 0.6,
}

var main_scene

signal conical_changed(color_change : String)
signal fail(fail_position : Vector3)

func _ready():
	drain_poured.connect(_on_drained_poured)

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
		flask.queue_free()
		#fail.emit(position)
		var explosion = explosion_scene.instantiate()
		explosion.position = position
		self.add_child(explosion)
		
func _on_drained_poured(activate_chemical : String):
	print("pouring activate chemical : ", activate_chemical)
