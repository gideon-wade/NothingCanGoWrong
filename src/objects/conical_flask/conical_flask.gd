extends RigidBody3D

@onready var beaker = $beaker
@onready var liquid : GPUParticles3D = $Liquid
@export var color : Vector3

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
	liquid.visible = rotation_degrees.z > 90.0 and rotation_degrees.z < 270.0
