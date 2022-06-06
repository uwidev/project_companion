# Manages loading neccessary assets/data for a locationor event to run. 
# This includes # all sprites, background, audio, and any other specialized 
# resource.
extends Node

# All assets are to be loaded and accessed on ResDB.
var ResDB : Dictionary

func _init():
	_build_resource_db()

# given a dialogue resource, load only what's required of this scene
# but since this is speedy prototype, fuck it we load every cg resource
#
# also only really appears to support character resources at the moment.
func _build_resource_db():
	var dir := Directory.new()
	if dir.open("res://cg/char") != OK:
		return {}
		
	if dir.list_dir_begin() != OK:
		dir.list_dir_end()
		return {}
		
	var filename = dir.get_next()
	while filename != "":
		if filename.ends_with(".tres"):
			var resource = load("res://cg/char".plus_file(filename))
			ResDB[resource.name] = resource.sprite
		filename = dir.get_next()
	dir.list_dir_end()
