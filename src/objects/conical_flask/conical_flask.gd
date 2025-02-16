extends RigidBody3D

@onready var beaker = $beaker
@onready var liquid : GPUParticles3D = $Liquid
@export var color : Vector3

var draw_particles : bool : 
	set(val) : 
		if val and not liquid.visible:
			liquid.restart()
		liquid.visible = val
		

#@onready var chemical = $beaker/juice
# Called when the node enters the scene tree for the first time.
func _ready():
	var chemical : MeshInstance3D = beaker.get_node("juice")
	var shader_material : ShaderMaterial = load("res://models/liquid_materials/color_changer.tres")
	var dupe := shader_material.duplicate()
	chemical.mesh.surface_get_material(0).next_pass = dupe
	var particle_process_material : ParticleProcessMaterial = ParticleProcessMaterial.new()
	#particle_process_material.color = 
	liquid.process_material.color = Color(color.x,color.y,color.z,1.0)
	liquid.visible = false
	dupe.set_shader_parameter("color", color)
func _physics_process(delta):
	if rotation_degrees.z > 90.0 and rotation_degrees.z < 270.0:
		#liquid.restart()
		draw_particles = true
	else : 
		#liquid.restart()
		draw_particles = false
	 
	#liquid.visible = not is_facing_downward()
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
