extends RigidBody3D

@onready var beaker = $beaker
@export var color : Vector3
#@onready var chemical = $beaker/juice
# Called when the node enters the scene tree for the first time.
func _ready():
	var chemical : MeshInstance3D = beaker.get_node("juice")
	var shader_material : ShaderMaterial = load("res://models/liquid_materials/color_changer.tres")
	chemical.mesh.surface_get_material(0).next_pass = shader_material
	shader_material.set_shader_parameter("color", color)
func _process(delta):
	pass
