extends Node3D
@onready var debris: GPUParticles3D = $Debris
@onready var fire: GPUParticles3D = $Fire
@onready var smoke: GPUParticles3D = $Smoke
@onready var sound: AudioStreamPlayer3D = $Sound

@export var explosion_radius: float = 5.0
@export var explosion_force: float = 10.0

func _ready():
	debris.emitting = true
	fire.emitting = true
	smoke.emitting = true
	sound.play()
	explode()
	await get_tree().create_timer(2.1).timeout
	queue_free()

func explode() -> void:
	var space_state = get_world_3d().direct_space_state
	# Spherical explosion
	var sphere_shape = SphereShape3D.new()
	sphere_shape.radius = explosion_radius
	
	# Find objects in sphere
	var query = PhysicsShapeQueryParameters3D.new()
	query.shape = sphere_shape
	query.transform = Transform3D(Basis(), global_transform.origin)
	query.collide_with_bodies = true
	var results = space_state.intersect_shape(query)
	for result in results:
		var body = result.collider
		if body is StaticBody3D:
			continue
		var direction = (body.global_transform.origin - global_transform.origin).normalized()
		if direction == Vector3(0, 0, 0):
			continue
		var distance = global_transform.origin.distance_to(body.global_transform.origin)
		var force_magnitude = explosion_force / max(distance, 1.0)
		if body is RigidBody3D:
			direction += Vector3(0, 1, 0)
			body.apply_impulse(direction * force_magnitude)
		elif body is CharacterBody3D:
			direction += Vector3(0, 0.5, 0)
			body.explosion_push_player(direction * force_magnitude)
