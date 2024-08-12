extends StaticBody3D

#check to see if door is open
var is_open = false
#check interaction
var interactable = true

#@export is the same as a public variable
@export var animation_player: AnimationPlayer

func _interact():
	#When the animtion is done playing set back to true
	if interactable == true:
		interactable = false
		is_open = !is_open
		
		if is_open == false:
			animation_player.play("close")
		if is_open == true:
			animation_player.play("open")
		
		#Create a timer based on how long the animtion will play
		#Will only count when game is not paused
		await get_tree().create_timer(0.4, false).timeout
		interactable = true
