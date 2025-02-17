class_name ConicalFlask extends RigidBody3D

@export var color : Vector3
@export var debug_show_id := false

@onready var beaker = $beaker
@onready var raycast : RayCast3D = $RayCast3D
@onready var label : Label3D = $Label3D


var liquid_scene := preload("res://src/objects/liquid/liquid.tscn")
var liquid : GPUParticles3D
var shader_material : ShaderMaterial = preload("res://models/liquid_materials/color_changer.tres")


# id is used for mix chemicals so you don't two chemicals twice in a loop
var id : int
var last_mixed_with_id: int = -1  # -1 means never mixed
var known_ids : Dictionary = {}

var delete_me = 0

var draw_particles : bool : 
	set(val) : 
		if val and not liquid.visible:
			liquid.restart()
		liquid.visible = val
		
func _ready():
	id = generate_id()
	set_color()
	

func set_color():
	if not is_node_ready():
		return
	var chemical : MeshInstance3D = beaker.get_node("juice")
	var material := shader_material.duplicate(true)
	material.set_shader_parameter("color", color)
	chemical.set_surface_override_material(0, material)

	for child in get_children():
		if child is GPUParticles3D:
			remove_child(child)
	
	liquid = liquid_scene.instantiate().duplicate()
	liquid.process_material = liquid.process_material.duplicate(true)
	add_child(liquid)
	liquid.process_material.color = Color(color.x,color.y,color.z,1.0)
	liquid.visible = false
	print("color changed ", color)
	
func _physics_process(delta):
	if is_facing_down():
		draw_particles = true
		raycast.enabled = true
	else : 
		draw_particles = false
		raycast.enabled = false
	# pouring logic
	raycast.look_at(raycast.global_transform.origin + Vector3(0, 0, -10), Vector3.UP)
	var colider = raycast.get_collider()
	if colider != null and colider is ConicalFlask :
		var other_flask : ConicalFlask = colider
		#print("known ids nuts : ", known_ids, " my id : ", id)
		
		if other_flask.id not in known_ids and is_below(other_flask) and is_facing_up():
			print("pouring into flask")
			other_flask.color = color.lerp(other_flask.color,0.5)
			other_flask.set_color()
			#known_ids[other_flask.id] = false
			#other_flask.known_ids.clear()
			#known_ids[other_flask.id] = false
			var new_id = other_flask.generate_id()
			other_flask.id = new_id
			known_ids[new_id] = true
			if id in other_flask.known_ids: # I don't think this works
				other_flask.known_ids.erase(id)
			
			if debug_show_id:
				$Label3D2.text = "known ids nuts : " + str(known_ids)

			
func generate_id() -> int:
	id = randi()
	if debug_show_id:
		label.text = str(id)
	#known_ids.clear()
	return id

func is_below(other_object: Node3D) -> bool:
	# Get the global positions of both objects
	var my_position = global_position
	var other_position = other_object.global_position
	
	# Compare Y coordinates (in Godot, Y axis points up)
	return my_position.y > other_position.y

func is_facing_up() -> bool:
	var object_up = global_transform.basis.y
	var angle = object_up.angle_to(Vector3.UP)
	#var angel = Vector3.UP.angle_to(global_position)
	return angle < PI/1.8

func is_facing_down() -> bool:
	var object_up = global_transform.basis.y
	var angle = object_up.angle_to(Vector3.UP)
	
	# If angle is greater than 90 degrees (PI/2), it's roughly facing down
	return angle > PI/2.5
