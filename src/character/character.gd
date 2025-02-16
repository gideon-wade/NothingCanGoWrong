extends CharacterBody3D


@export var vertical_sensitivity := 0.2
@export var horizontal_sensitivity := 0.2

@export var visuals : Node3D 
@export var camera : Node3D
@export var interation : RayCast3D
@export var hand : Marker3D

var picked_object : RigidBody3D

@export var pull_power := 5.0

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	var b = hand.global_transform.origin
	print("b : ",b)
	print("self ", self.global_transform.origin)
func _input(event):
	if event.is_action_pressed("pickup"):
		if picked_object == null:
			pick_object()
		else:
			picked_object = null
	if event is InputEventMouseMotion:
		self.rotate_y( -deg_to_rad(event.relative.x * vertical_sensitivity))
		camera.rotate_x(-deg_to_rad(event.relative.y * horizontal_sensitivity))
		visuals.rotate_y(deg_to_rad(event.relative.x * horizontal_sensitivity))
		var x_rotation = camera.rotation_degrees.x
		x_rotation = clamp(x_rotation, -85, 50)  
		camera.rotation_degrees.x = x_rotation

func _physics_process(delta):
	
	if picked_object != null:
		# put the object at the hand node's position
		var a = picked_object.global_transform.origin
		var b = hand.global_transform.origin
		print("a : ",a, " b : ", b)
		picked_object.set_linear_velocity((b-a)*pull_power)
		# orient the object upwards
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "up", "down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
	
func pick_object():
	var colider = interation.get_collider()
	if colider != null:
		print("colider", colider)
	if colider != null and colider is RigidBody3D:
		picked_object = colider
