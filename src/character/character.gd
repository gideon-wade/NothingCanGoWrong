extends CharacterBody3D


@export var vertical_sensitivity := 0.5
@export var horizontal_sensitivity := 0.5

@export var visuals : Node3D 
@export var camera : Node3D
const SPEED = 5.0
const JUMP_VELOCITY = 4.5

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventMouseMotion:
		self.rotate_y( -deg_to_rad(event.relative.x * vertical_sensitivity))
		camera.rotate_x(-deg_to_rad(event.relative.y * horizontal_sensitivity))
		visuals.rotate_y(deg_to_rad(event.relative.x * horizontal_sensitivity))
		var x_rotation = camera.rotation_degrees.x
		x_rotation = clamp(x_rotation, -85, 50)  
		camera.rotation_degrees.x = x_rotation

func _physics_process(delta):
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
