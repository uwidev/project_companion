extends Node

# All events are to be loaded and accessed on EventDB.
# EventDB is a dictionary, with additional dictionaries that further categorize
# events based on what trigger-type it follows.
#
# Interaction-triggers are further categorized based on the object
# that is being interacted
var EventDB : Dictionary

func _init():
	_build_resource_db()

func _build_resource_db():
	var dir := Directory.new()
	if dir.open("res://events") != OK:
		return {}
		
	if dir.list_dir_begin() != OK:
		dir.list_dir_end()
		return {}
		
	# Generate event categories
	EventDB["Interaction"] = {}
	EventDB["Time"] = []
	EventDB["Event"] = []
	
	# Populate dictionary	
#	var filename = dir.get_next()
#	while filename != "":
#		if filename.ends_with(".tres"):
#			# Add the event to the database
#			var resource : EventResource = load("res://events".plus_file(filename))
#			if resource.active:
#				if resource.trigger_by_interaction:					
#					if !(resource.on_object_name in EventDB["Interaction"].keys()):
#						EventDB["Interaction"][resource.on_object_name] = []
#					EventDB["Interaction"][resource.on_object_name].append(resource)
#
#				if resource.trigger_by_time:
#					EventDB["Time"].append(resource)
#
#				if resource.trigger_by_event:
#					EventDB["Event"].append(resource)
#
#
#			# Set up event signal connections
##			resource.connect("event_finished", EventManager, "on_successful_event")
#
#		filename = dir.get_next()
#	dir.list_dir_end()
