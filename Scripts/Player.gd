extends CharacterBody3D

const JUMP_VELOCITY = 4.5
const SENSITIVITY = 0.001

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var speed = 5.0

@onready var camera = $Pivot/Camera3D
@onready var raycast_01 = $RayCast01

func _ready():
	#Have mouse cursor part of the game window
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	#Rotate player model when mouse is moved left or right
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, -1, 1)

func _process(delta):
	if raycast_01.is_colliding():
		var hit_object = raycast_01.get_collider()
		if hit_object.has_method("_interact") and Input.is_action_just_pressed("interact"):
			#print("opn")
			hit_object._interact()
		if Input.is_action_pressed("jump") and Input.is_action_pressed("move_forward"):
			#TODO Fix the wall climbing to prevent infinte climbing
			print("Velocity Y: " , velocity.y)
			velocity.y += 0.1

func _physics_process(delta):
	#print("Speed is: ", speed)
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
		
	#Have speed slower when not moving forward
	if Input.is_action_pressed("move_forward") and !raycast_01.is_colliding():
		speed += 0.03
		if speed > 10.0:
			speed = 10.0
	elif Input.is_action_pressed("move_forward") and raycast_01.is_colliding() and speed >= 3.0:
		speed -= 0.2
	else:
		speed = 3.0

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	if Input.is_action_pressed("jump") and Input.is_action_pressed("move_left"):
		velocity.y -= (gravity*2) * delta
		speed = 7
	if Input.is_action_pressed("jump") and Input.is_action_pressed("move_right"):
		velocity.y -= (gravity*2) * delta
		speed = 7
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	#Input.get_vector goes by neg(x), pos(x), neg(y), pos(y)
	#X is horizontal and Z is forward and backward
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	#Make sure player is still on the floor
	if is_on_floor():
		if direction:
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
		else:
			#slows player instead of instantly stopping
			velocity.x = lerp(velocity.x, direction.x * speed, delta * 6.5)
			velocity.z = lerp(velocity.z, direction.z * speed, delta * 6.5)
	else:
		#Allow player to still move in air when movement is no longer pressed
		velocity.x = lerp(velocity.x, direction.x * speed, delta * 2.0)
		velocity.z = lerp(velocity.z, direction.z * speed, delta * 2.0)
		
	#TODO Fix jitter from crouching down
	if Input.is_action_pressed("crouch"):
		scale.y = 0.5
		velocity.x = (direction.x * speed)/3
		velocity.z = (direction.z * speed)/3
	else:
		scale.y = 1

	move_and_slide()
