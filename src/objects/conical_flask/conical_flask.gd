class_name ConicalFlask extends RigidBody3D

@onready var beaker = $beaker
@onready var liquid : GPUParticles3D = $Liquid

var shader_material : ShaderMaterial = preload("res://models/liquid_materials/color_changer.tres")
@export var color : Vector3 : 
	set(val):
		_set_color()
		color = val
		

@onready var raycast : RayCast3D = $RayCast3D

# id is used for mix chemicals so you don't two chemicals twice in a loop
var id : int
var known_ids : Dictionary = {}

var draw_particles : bool : 
	set(val) : 
		if val and not liquid.visible:
			liquid.restart()
		liquid.visible = val
		
#@onready var chemical = $beaker/juice
# Called when the node enters the scene tree for the first time.
func _ready():
	_set_color()

func _set_color():
	if not is_node_ready():
		return
	var chemical : MeshInstance3D = beaker.get_node("juice")
	var dupe := shader_material.duplicate()
	chemical.mesh.surface_get_material(0).next_pass = dupe
	var particle_process_material : ParticleProcessMaterial = ParticleProcessMaterial.new()
	chemical.set_surface_override_material(0, chemical.mesh.surface_get_material(0).duplicate())

	#chemical.mesh.set_surface_override_material(0, chemical.mesh.surface_get_material(0).duplicate())
	#particle_process_material.color = 
	liquid.process_material.color = Color(color.x,color.y,color.z,1.0)
	liquid.visible = false
	dupe.set_shader_parameter("color", color)

func _physics_process(delta):
	if rotation_degrees.z > 90.0 and rotation_degrees.z < 270.0:
		#liquid.restart()
		draw_particles = true
		raycast.enabled = true
	else : 
		#liquid.restart()
		draw_particles = false
		raycast.enabled = false
		
	# pouring logic
	raycast.look_at(raycast.global_transform.origin + Vector3(0, 0, -10), Vector3.UP)
	var colider = raycast.get_collider()
	if colider != null and colider is ConicalFlask:
		
		var other_flask : ConicalFlask = colider
		if other_flask.id not in known_ids:
			print("pouring into flask")
			
			other_flask.color = color * other_flask.color
			var new_id = randi()
			other_flask.id = new_id
			known_ids[new_id] = true
	
func get_down_angle() -> float:
	var forward_direction = -global_transform.basis.z
	var down_vector = Vector3.DOWN
	return rad_to_deg(forward_direction.angle_to(down_vector))
	
# Assuming your object is a Node3D (or any derived class like CharacterBody3D)
func is_facing_downward() -> bool:
	# Get the object's forward direction (negative Z axis)
	var forward_direction = -global_transform.basis.z
	
	# Global down vector
	var down_vector = Vector3.DOWN  # Same as Vector3(0, -1, 0)
	
	# Get the dot product between the forward direction and down vector
	var dot_product = forward_direction.dot(down_vector)
	
	# If dot product is positive, the object is facing more downward than upward
	# (angle between vectors is less than 90 degrees)
	return dot_product > 0
