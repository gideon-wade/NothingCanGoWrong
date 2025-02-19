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
@export var pull_power := 25.0


var is_pouring := false
var falling := false
var mouse_captured := true
const SPEED = 5.0
const JUMP_VELOCITY = 4.5
var current_collider


const LEFT = 0
const RIGHT = 1

var is_alive : bool = true
var push_decay: float = 5.0

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
	if event is InputEventMouseMotion and is_alive:
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
		left_hand_object.set_linear_velocity((b-a)*pull_power)
		left_hand_object.look_at(camera.global_transform.origin, Vector3(0,1,0), true)
		left_hand_object.rotate_y(-PI/4)
		
		if is_pouring and left_hand_object is ConicalFlask:
			left_hand_object.rotation = Vector3(0,self.rotation.y,-2.1)
		#else:
		#	
	if right_hand_object != null:
		# put the object at the hand node's position
		var a = right_hand_object.global_transform.origin
		var b = right_hand.global_transform.origin
		right_hand_object.set_linear_velocity((b-a)*pull_power)
		right_hand_object.look_at(camera.global_transform.origin, Vector3(0,1,0))
		right_hand_object.rotate_y(PI/4)
		if is_pouring and right_hand_object is ConicalFlask:
			right_hand_object.rotation = Vector3(0,self.rotation.y,2.1)
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if is_alive:
		# Handle jump.
		if Input.is_action_just_pressed("ui_accept") and is_on_floor():
			velocity.y = JUMP_VELOCITY

		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var input_dir = Input.get_vector("left", "right", "up", "down")
		var base_velocity = Vector3.ZERO
		if input_dir != Vector2.ZERO:
			var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
			base_velocity.x = direction.x * SPEED
			base_velocity.z = direction.z * SPEED
		else:
			base_velocity.x = move_toward(velocity.x, 0, SPEED)
			base_velocity.z = move_toward(velocity.z, 0, SPEED)
		
			
		velocity.x = base_velocity.x
		velocity.z = base_velocity.z
	else:
		if is_on_floor() and falling:
			velocity = Vector3(0, 0, 0)
			rotation.z = clamp(rotation.z-0.05, -1.6, 0)
		elif not is_on_floor():
			falling = true
			velocity *= 0.975
	
	move_and_slide()
	_check_interactability()
	
func handle_hand(hand: int):
	var collider = interation.get_collider()
	if hand == LEFT:
		if left_hand_object != null:
			left_hand_object.linear_velocity *= 0.5
			left_hand_object.get_node("CollisionShape3D").disabled = false
			left_hand_object = null
		elif collider != null and collider is RigidBody3D:
			collider.get_node("CollisionShape3D").disabled = true
			await get_tree().create_timer(0.01).timeout
			left_hand_object = collider
	elif hand == RIGHT:
		if right_hand_object != null:
			#right_hand_object.linear_velocity = camera.get_global_transform().basis.z * -10
			right_hand_object.linear_velocity *= 0.5
			right_hand_object.get_node("CollisionShape3D").disabled = false
			right_hand_object = null
		elif collider != null and collider is RigidBody3D:
			collider.get_node("CollisionShape3D").disabled = true
			await get_tree().create_timer(0.01).timeout
			right_hand_object = collider
			
			
func explosion_push_player(push: Vector3) -> void:
	velocity = push
	is_alive = false
	falling = false
	force_update_transform()
	if left_hand_object != null:
		left_hand_object.apply_impulse(push / 3.0)
		left_hand_object.get_node("CollisionShape3D").disabled = false
		left_hand_object = null
	if right_hand_object != null:
		right_hand_object.apply_impulse(push / 3.0)
		right_hand_object.get_node("CollisionShape3D").disabled = false
		right_hand_object = null
	$Respawn.start()

func _check_interactability() -> void:
	var new_collider = null
	if interation.is_colliding():
		new_collider = interation.get_collider()

	if current_collider and current_collider != new_collider:
		if current_collider.has_method("remove_outline"):
			current_collider.remove_outline()
		current_collider = null

	if new_collider and new_collider != current_collider:
		if new_collider.has_method("show_outline"):
			new_collider.show_outline()
		current_collider = new_collider

func _on_respawn_timeout() -> void:
	get_tree().reload_current_scene()
