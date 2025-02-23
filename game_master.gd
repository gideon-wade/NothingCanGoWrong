extends Node

signal drain_poured(activate_chemical : String)

var explosion_scene := preload("res://explosion.tscn")
var interactable = [ConicalFlask, ClipBoard]

var recipies = {
	#Tutorail
	"Limyl,Sepirium": "Cacticum-4",
	"Limyl,Cacticum-4": "Applumid",
	#Lvl 1
	"Oceamid,Redamin": "Grass Juice",
	"Grass Juice,Applumid": "Cadrulium",
	"Cadrulium,Grass Juice": "Princiade",
	"Princiade,Oceamid": "Dracula's Blood",
	"Dracula's Blood,Applumid": "Laudle",
	#Lvl 2
	"Laudle,Princiade": "Washing Liquid",
	"Laudle,Oxofizz": "Cider",
	"Applumid,Cider": "Tonic",
	"Cacticum-4,Washing Liquid": "Jam",
	"Tonic,Jam": "Water",
}

var colors = {
	#Tutorial
	"Limyl": Vector3(0, 200/256.0, 0),
	"Sepirium": Vector3(240/256.0, 240/256.0, 240/256.0),
	"Cacticum-4": Vector3(0, 100/256.0, 0),
	#Lvl 1
	"Oceamid": Vector3(0, 0, 1),
	"Redamin": Vector3(1, 0, 0),
	"Applumid": Vector3(1, 1, 0),
	"Grass Juice": Vector3(0, 1, 0),
	"Cadrulium": Vector3(128/256.0, 0, 128/256.0),
	"Princiade": Vector3(1, 100/256.0, 150/256.0),
	"Dracula's Blood": Vector3(150/256.0, 0, 0),
	"Laudle": Vector3(150/256.0, 1, 150/256.0),
	#Lvl 2
	#"Liquid Stone": Vector3(0, 0, 0),
	"Oxofizz": Vector3(232/256.0, 100/256.0, 0),
	"Washing Liquid": Vector3(140/256.0, 140/256.0, 140/256.0),
	"Cider": Vector3(75/256.0, 200/256.0, 0),
	"Tonic": Vector3(244/256.0, 252/256.0, 136/256.0),
	"Jam": Vector3(256/256.0, 80/256.0, 80/256.0),
	"Water": Vector3(80/256.0, 255/256.0, 256/256.0),
}
var substance_glow = {
	#Tutorial
	"Limyl": 0.35,
	"Sepirium": 0.8,
	"Cacticum-4": 0.1,
	#Lvl 1
	"Oceamid": 0.45,
	"Redamin": 0.3,
	"Applumid": 0.1,
	"Grass Juice": 0.1,
	"Cadrulium": 0.6,
	"Princiade": 0.9,
	"Dracula's Blood": 0.2,
	"Laudle": 0.6,
	#Lvl 2
	"Liquid Stone": 0.1,
	"Oxofizz": 0.1,
	"Washing Liquid": 0.4,
	"Cider": 0.5,
	"Tonic": 0.3,
	"Jam": 0.2,
	"Water": 0.6,
}
var substance_bubbles = {
	#Tutorial
	"Limyl": false,
	"Sepirium": false,
	"Cacticum-4": false,
	#Lvl 1
	"Oceamid": true,
	"Redamin": false,
	"Applumid": false,
	"Grass Juice": false,
	"Cadrulium": true,
	"Princiade": true,
	"Dracula's Blood": false,
	"Laudle": true,
	#Lvl 2
	"Liquid Stone": false,
	"Oxofizz": false,
	"Washing Liquid": false,
	"Cider": true,
	"Tonic": true,
	"Jam": false,
	"Water": false,
}


var main_scene
var can_explode := true

func _ready():
	drain_poured.connect(_on_drained_poured)

func mix(substance1: String, substance2: String, flask: ConicalFlask, position : Vector3) -> void:
	var comb1 = recipies.get(substance1+","+substance2, "fail")
	var comb2 = recipies.get(substance2+","+substance1, "fail")
	var out = comb1 if comb1 != "fail" else comb2
	
	
		
	if out != "fail":
		flask.substance_name = out
		flask.color = colors[out]
		flask.set_color()

	else:
		#fail.emit(position)
		if can_explode:
			flask.queue_free()
			var explosion = explosion_scene.instantiate()
			explosion.position = position
			self.add_child(explosion)
			can_explode = false
			$Cooldown.start()

	if out == "Water":
		print("you won")
		
		await get_tree().create_timer(2.).timeout
		var player = get_tree().get_nodes_in_group("Player")[0]
	
		var victory = get_tree().get_nodes_in_group("Victory")[0]
		var marker = victory.get_node("Marker3D")
		player.global_position = marker.global_position
	
func _on_drained_poured(activate_chemical : String):
	print("pouring activate chemical : ", activate_chemical)

func _on_cooldown_timeout() -> void:
	can_explode = true
