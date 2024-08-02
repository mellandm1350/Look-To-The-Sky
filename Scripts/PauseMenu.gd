extends Control

func _ready():
	hide()

#Could add animation to resume and pause in the future
func _resume():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	hide()
	get_tree().paused = false
	
func  _paused():
	get_tree().paused = true
	show()
	

func _process(delta):
	if Input.is_action_just_pressed("pause") and !get_tree().paused:
		_paused()
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
	elif Input.is_action_just_pressed("pause") and get_tree().paused:
		_resume()
		

func _on_resume_pressed():
	_resume()
	
func _on_restart_pressed():
	_resume()
	get_tree().reload_current_scene()
	
func _on_quit_pressed():
	get_tree().quit()



