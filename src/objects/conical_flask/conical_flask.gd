class_name ConicalFlask extends Node3D

@export var substance_name : String
@export var debug_show_id := false

@onready var body = $"beaker/glass-rigid"
@onready var glass_rigid: MeshInstance3D = $"beaker/glass-rigid/glass-rigid"
@onready var raycast : RayCast3D = $UI/RayCast3D
@onready var label : Label3D = $UI/Label3D
@onready var audio: AudioStreamPlayer3D = $UI/AudioStreamPlayer3D
@onready var substance_glow: OmniLight3D = $UI/OmniLight3D
const SHADER_MATERIAL = preload("res://src/objects/conical_flask/shader_material.tres")
const POURING_INTO_LIQUID_1 = preload("res://src/audio/conical_flask/pouring_into_liquid_1.mp3")
const POURING_INTO_LIQUID_2 = preload("res://src/audio/conical_flask/pouring_into_liquid_2.mp3")
const OBJECT_OUTLINER = preload("res://models/textures/object_outliner.tres")
const HIT_SOUNDS = [
	preload("res://src/audio/conical_flask/glass_colliding_1.mp3"),
	preload("res://src/audio/conical_flask/glass_colliding_2.mp3"),
	preload("res://src/audio/conical_flask/glass_colliding_3.mp3"),
	preload("res://src/audio/conical_flask/glass_colliding_4.mp3"),
	preload("res://src/audio/conical_flask/glass_colliding_5.mp3"),
]

var liquid_scene := preload("res://src/objects/liquid/liquid.tscn")
var liquid : GPUParticles3D
var shader_material : ShaderMaterial = preload("res://models/liquid_materials/color_changer.tres")
var rng = RandomNumberGenerator.new()

# id is used for mix chemicals so you don't two chemicals twice in a loop
var color : Vector3
var id : int
var last_mixed_with_id: int = -1  # -1 means never mixed
var known_ids : Array = []


var delete_me = 0
var was_colliding : bool = false

var draw_particles : bool : 
	set(val) : 
		if val and not liquid.visible:
			liquid.restart()
		liquid.visible = val
		
func _ready():
	body.contact_monitor = true
	body.max_contacts_reported = 1
	id = randi()
	show_name()
	set_color()
	body.get_node("glass-rigid-outline").material_overlay = OBJECT_OUTLINER

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
	
	for child in get_children():
		if child is GPUParticles3D:
			remove_child(child)
	
	liquid = liquid_scene.instantiate().duplicate()
	liquid.process_material = liquid.process_material.duplicate(true)
	#liquid.global_position = body.global_position
	$UI.add_child(liquid)
	liquid.process_material.color = Color(color.x, color.y, color.z, 1.0)
	liquid.visible = false
	var liquid_glow = liquid.get_child(0)
	liquid_glow.light_color = Color(color.x, color.y, color.z)
	liquid_glow.light_energy = GameMaster.substance_glow[substance_name]
	liquid_glow.omni_range = 1.0
	liquid_glow.shadow_enabled = false
	liquid_glow.visible = true
	GameMaster.new_substance_color(liquid.process_material.color.to_html(false))
	var material2 = SHADER_MATERIAL.duplicate(true)
	var liquid_color = Color(color.x, color.y, color.z, 255)
	material2.set_shader_parameter("liquid_color", liquid_color)
	material2.set_shader_parameter("foam_color", liquid_color)
	glass_rigid.material_overlay = material2
	
func _physics_process(delta):
	$UI.global_position = body.global_position
	$UI.global_rotation = body.global_rotation
	# Checks collision of other Rigidbody3D
	if body.get_contact_count() > 0:
		if not was_colliding:
			var number = randi_range(0,4)
			audio.stream = HIT_SOUNDS[number]
			audio.set_pitch_scale(rng.randf_range(0.9, 1.1))
			audio.play()
			was_colliding = true
			if body.linear_velocity.length() > 4:
				GameMaster.mix("FAST", "FAST", self, body.global_position)
	else:
		was_colliding = false
		
	if debug_show_id:
		$Label3D2.text = "known ids nuts : " + str(known_ids)
		
	if is_facing_down():
		draw_particles = true
		raycast.enabled = true
	else: 
		draw_particles = false
		raycast.enabled = false
		known_ids = []
		return
		
	# pouring logic
	raycast.look_at(raycast.global_transform.origin + Vector3(0, 0, -10), Vector3.UP)
	var colider = raycast.get_collider()
	if colider != null and colider.get_name() == "glass-rigid":
		colider = colider.get_parent().get_parent()
	if colider != null and colider is ConicalFlask:
		var other_flask : ConicalFlask = colider
		if other_flask.id not in known_ids and is_below(other_flask) and other_flask.is_facing_up():
			if !other_flask.audio.is_playing():
				var number = randi_range(1,2)
				if number == 1:
					other_flask.audio.stream = POURING_INTO_LIQUID_1
				else:
					other_flask.audio.stream = POURING_INTO_LIQUID_2
				other_flask.audio.set_pitch_scale(rng.randf_range(0.9, 1.1))
				other_flask.audio.play()
			known_ids.append(other_flask.id)
			await get_tree().create_timer(0.25).timeout
			var new_collider = raycast.get_collider()
			if new_collider != null and new_collider.get_name() == "glass-rigid":
				new_collider = new_collider.get_parent().get_parent()
			if new_collider == colider and is_facing_down():
				if not other_flask:
					return
				if is_below(other_flask) and other_flask.is_facing_up():
					GameMaster.mix(substance_name, other_flask.substance_name, other_flask, other_flask.position)
					other_flask.show_name()
			
func show_name():
	#if debug_show_id:
	label.text = substance_name

func is_below(other_object: Node3D) -> bool:
	# Get the global positions of both objects
	var my_position = body.global_position
	var other_position = other_object.body.global_position
	# Compare Y coordinates (in Godot, Y axis points up)
	return my_position.y > other_position.y

func is_facing_up() -> bool:
	var object_up = global_transform.basis.y
	var angle = object_up.angle_to(Vector3.UP)
	#var angel = Vector3.UP.angle_to(global_position)
	return angle < PI/2.0

func is_facing_down() -> bool:
	var object_up = body.global_transform.basis.y
	var angle = object_up.angle_to(Vector3.UP)
	
	# If angle is greater than 90 degrees (PI/2), it's roughly facing down
	return angle > PI/2.5

func set_linear_velocity(vel: Vector3) -> void:
	body.set_linear_velocity(vel)

func show_outline() -> void:
	body.get_node("glass-rigid-outline").visible = true

func remove_outline() -> void:
	body.get_node("glass-rigid-outline").visible = false
