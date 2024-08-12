extends StaticBody3D

#@export is the same as a public variable
@export var animation_player: AnimationPlayer

#check to see if door is open
var is_open = false
#check interaction
var interactable = true

func _interact():
	pass


