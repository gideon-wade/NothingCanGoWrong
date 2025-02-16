extends Node3D
@onready var debris: GPUParticles3D = $Debris
@onready var fire: GPUParticles3D = $Fire
@onready var smoke: GPUParticles3D = $Smoke
@onready var sound: AudioStreamPlayer3D = $Sound

func _ready():
	debris.emitting = true
	fire.emitting = true
	smoke.emitting = true
	#sound.play()
	await get_tree().create_timer(2.0).timeout
	queue_free()
