extends Node

# All events are to be loaded and accessed on EventDB.
# EventDB is a dictionary, with additional dictionaries that further categorize
# events based on what trigger-type it follows.
#
# Interaction-triggers are further categorized based on the object
# that is being interacted
var db : Dictionary

signal references_updated


# Built-in
func _init():
	db["interact"] = {}
	db["event"] = []
	
func _ready():
	_build_resource_db()


# Public



# Private
func _build_resource_db():
	var dir_string = "res://03_events"
	var dir := Directory.new()
	if dir.open(dir_string) != OK:
		return {}
		
	if dir.list_dir_begin() != OK:
		dir.list_dir_end()
		return {}

	# Populate dictionary	
	var filename = dir.get_next()
	while filename != "":
		if filename.ends_with(".tscn"):
			# Instance the node and let it init itself
			var event_scene : PackedScene = load(dir_string.plus_file(filename))
			var event : NodeEventRoot = event_scene.instance()
			_register_series(event)

		filename = dir.get_next()
	dir.list_dir_end()

	emit_signal("references_updated")


func _register_series(event: NodeEventRoot):
	if event.trigger_by_interact:
		if !(event.with in db["interact"]):
			db["interact"][event.with] = []
		db["interact"][event.with].append(event)
		
	elif event.trigger_by_events:
		db["event"].append(event)
