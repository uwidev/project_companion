# Manages and displays the various sprites and inserts on the screen
extends Node

# given a character:string, show that character on screen
func show_character(name:String, expression:String) -> void:
	var texture = ResourceDB.ResDB[name][expression]
	var sprite := Sprite.new()
	sprite.texture = texture
	sprite.set_name(name)

	# how we just need to position the sprite whereever we need them
	get_tree().get_current_scene().add_child(sprite)
	pass
