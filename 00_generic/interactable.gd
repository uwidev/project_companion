class_name Interactable
extends Node2D
# A thing that can be interacted with.

signal interacted

var _is_interactable := false
var events : Array


func _init():
	yield(EventManager, "ready")
	connect("interacted", EventManager, "on_successful_interaction")
	
	# Check current directory for a folder events
	# for each folder in events, load main.tres as an event in events
	var dir := Directory.new()
	
	if dir.open("res://01_concrete/interactables/%s/events" % name.to_lower()) != OK:
		assert("events directory does not exist on interactable \"%s\"" % name)

	dir.list_dir_begin()
	var folder = dir.get_next()
	while folder != "" and dir.current_is_dir():
		if folder == "." or folder == "..":
			folder = dir.get_next()
			continue
		var event_dir = dir.get_current_dir() + "/" + folder + "/main.tres"
		var event = load(event_dir)
		events.append(event)
		folder = dir.get_next()
	
	dir.list_dir_end()


func _can_be_interacted_by(other):
	# Must be overridden by the child script.
	# This will define constraints on what and how this can be intereacted.
	return true
	
func _interact(other) -> bool:
	# Called by the other(?), passing themselves into the function.
	#
	# Needs to talk to the director, saying that this happened (or it didn't),
	# director then decides what happens next.
	if _can_be_interacted_by(other):
		emit_signal("interacted", [other, self])
		return true
	return false


func _on_Area2D_input_event(viewport, event, shape_idx):
	# The way for the player to _interact().
	if event is InputEventMouseButton:
		if event.button_index == 1 and event.pressed:
			_interact(get_tree().get_current_scene().find_node("Player", true, false))


func interact(other) -> bool:
	# Just a public method for _interact(). Called by AI.
	return _interact(other)


