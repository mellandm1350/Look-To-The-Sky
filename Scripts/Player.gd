extends CharacterBody3D


var speed = 5.0
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _input(event):
	#Rotate player model when mouse is moved left or right
	if event is InputEventMouseMotion:
		rotate(Vector3.UP, -event.relative.x * 0.001)
	
	#Have speed slower when not moving forward
	if Input.is_action_pressed("move_backward"):
		speed = 3.5
	elif Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
		speed = 4.0
	else:
		speed = 5.0

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	#Input.get_vector goes by neg(x), pos(x), neg(y), pos(y)
	#X is horizontal and Z is forward and backward
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
		
	#TODO Fix jitter from crouching down
	if Input.is_action_pressed("crouch"):
		scale.y = 0.5
		velocity.x = (direction.x * speed)/3
		velocity.z = (direction.z * speed)/3
	else:
		scale.y = 1

	move_and_slide()
