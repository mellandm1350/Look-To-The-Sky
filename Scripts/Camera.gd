extends Camera3D

func _ready():
	#Have mouse cursor part of the game window
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _process(delta):
	#Use clamp to lock in the max looking distance for up and down
	rotation.x = clamp(rotation.x, -1, 1)

func _input(event):
	#Rotate camera in when mouse is moved up or down
	if event is InputEventMouseMotion:
		rotate(Vector3.LEFT, event.relative.y * 0.001)
