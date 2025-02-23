class_name LoadingFlask extends ConicalFlask

func _ready():
	id = randi()
	set_color()
	body.get_node("glass-rigid-outline").material_overlay = OBJECT_OUTLINER
	draw_particles = true
	raycast.enabled = true
		
	GameMaster.mix("FAST", "FAST", self, body.global_position)

func set_color():
	if not is_node_ready():
		return
	color = GameMaster.colors[substance_name]
	var chemical : MeshInstance3D = body.get_node("juice")
	if chemical:
		var material := shader_material.duplicate(true)
		material.set_shader_parameter("color", color)
		chemical.set_surface_override_material(0, material)
		substance_glow.light_color = Color(color.x, color.y, color.z)
		substance_glow.light_energy = GameMaster.substance_glow[substance_name]
		substance_glow.omni_range = 1.0
		substance_glow.shadow_enabled = false
		substance_glow.visible = true
	
	liquid.process_material = liquid.process_material.duplicate()
	liquid.process_material.color = Color(color.x, color.y, color.z, 1.0)
	var material2 = SHADER_MATERIAL.duplicate()
	var liquid_color = Color(color.x, color.y, color.z, 1)
	material2.set_shader_parameter("liquid_color", liquid_color)
	material2.set_shader_parameter("foam_color", liquid_color)
	material2.set_shader_parameter("HasBubbles", GameMaster.substance_bubbles[substance_name])
	glass_rigid.material_overlay = material2

func _physics_process(_delta: float) -> void:
	return

func set_linear_velocity(vel: Vector3) -> void:
	body.set_linear_velocity(vel)
