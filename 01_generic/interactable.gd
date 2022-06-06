class_name Interactable
extends Node2D
# A thing that can be interacted with.
#
# Has an array events that references the various events that are to be
# triggered from this intereaction.


# Signals
signal interacted

# Vairables
var _is_interactable := false
var events : Array


# Public
func interact(other) -> bool:
	# Just a public method for _interact(). Called by AI.
	return _interact(other)


# Private
func _update_event_reference():
	events = EventDB.db['interact'][name]
	
func _can_be_interacted_by(other):
	# Must be overridden by the child script.
	# This will define constraints on what and how this can be intereacted.
	return true
	
func _interact(other):
	# Called by the other(?), passing themselves into the function.
	#
	# Needs to talk to the director, saying that this happened (or it didn't),
	# director then decides what happens next.
	_update_event_reference()
	
	if _can_be_interacted_by(other):
		var possible_events = []
		var ctx = [other, self]
		
		for event in events:
			var ev = event.get_valid_event(ctx)
			if ev:
				possible_events.append(ev)

		possible_events.shuffle() # shuffle for more random fun!
		possible_events.sort_custom(self, "_event_priority_cmp")
		possible_events.front().trigger(ctx)

func _event_priority_cmp(a, b):
	return a.get_priority() > b.get_priority()

func _on_Area2D_input_event(viewport, event, shape_idx):
	# The way for the player to _interact().
	if event is InputEventMouseButton:
		if event.button_index == 1 and event.pressed:
			_interact(get_tree().get_current_scene().find_node("Player", true, false))





