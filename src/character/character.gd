extends CharacterBody3D


@export var vertical_sensitivity := 0.2
@export var horizontal_sensitivity := 0.2

@export var visuals : Node3D 
@export var camera : Node3D
@export var interation : RayCast3D
@export var left_hand : Marker3D
@export var right_hand : Marker3D

var left_hand_object : RigidBody3D
var right_hand_object : RigidBody3D
@export var pull_power := 5.0

var is_pouring := false
var mouse_captured := true
const SPEED = 5.0
const JUMP_VELOCITY = 4.5

const LEFT = 0
const RIGHT = 1

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _input(event: InputEvent):
	if event.is_action_pressed("showMouse"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		mouse_captured = false
	if event.is_action_released("showMouse"):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		mouse_captured = true
	if not mouse_captured:
		return
	if event.is_action_pressed("leftHand"):
		handle_hand(LEFT)
	if event.is_action_pressed("rightHand"):
		handle_hand(RIGHT)
	if event.is_action_pressed("pour"):
		is_pouring = true
	if event.is_action_released("pour"):
		is_pouring = false
	if event is InputEventMouseMotion:
		self.rotate_y( -deg_to_rad(event.relative.x * vertical_sensitivity))
		camera.rotate_x(-deg_to_rad(event.relative.y * horizontal_sensitivity))
		visuals.rotate_y(deg_to_rad(event.relative.x * horizontal_sensitivity))
		var x_rotation = camera.rotation_degrees.x
		x_rotation = clamp(x_rotation, -85, 50)
		camera.rotation_degrees.x = x_rotation

func _physics_process(delta):
	
	if left_hand_object != null:
		# put the object at the hand node's position
		var a = left_hand_object.global_transform.origin
		var b = left_hand.global_transform.origin
		left_hand_object.position = lerp(a, b, 0.3)
		left_hand_object.set_linear_velocity(Vector3(0, 0, 0))
		left_hand_object.look_at(camera.global_transform.origin, Vector3(0,1,0), true)
		left_hand_object.rotate_y(-PI/4)
		#left_hand_object.rotate_x(PI/4)
		# orient the object upwards
		#TODO move pouring logic elsewhere
		if is_pouring:
			left_hand_object.rotation = Vector3(0,self.rotation.y,-2.1)
		#else:
		#	
	if right_hand_object != null:
		# put the object at the hand node's position
		var a = right_hand_object.global_transform.origin
		var b = right_hand.global_transform.origin
		right_hand_object.position = lerp(a, b, 0.3)
		right_hand_object.set_linear_velocity(Vector3(0, 0, 0))
		right_hand_object.look_at(camera.global_transform.origin, Vector3(0,1,0))
		right_hand_object.rotate_y(PI/4)
		if is_pouring:
			right_hand_object.rotation = Vector3(0,self.rotation.y,2.1)
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
	
func handle_hand(hand: int):
	var collider = interation.get_collider()
	if collider != null:
		print("colider ", collider)
	if hand == LEFT:
		if left_hand_object != null:
			#left_hand_object.linear_velocity = camera.get_global_transform().basis.z * -10
			left_hand_object.get_node("CollisionShape3D").disabled = false
			left_hand_object = null
		elif collider != null and collider is RigidBody3D:
			left_hand_object = collider
			collider.get_node("CollisionShape3D").disabled = true
	elif hand == RIGHT:
		if right_hand_object != null:
			#right_hand_object.linear_velocity = camera.get_global_transform().basis.z * -10
			right_hand_object.get_node("CollisionShape3D").disabled = false
			right_hand_object = null
		elif collider != null and collider is RigidBody3D:
			right_hand_object = collider
			collider.get_node("CollisionShape3D").disabled = true
