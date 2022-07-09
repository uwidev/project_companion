class_name Interactable
extends Node2D
# A thing that can be interacted with. Should be a child of an object or entity.
#
# Has an array events that references the various events that are to be
# triggered from this intereaction.


# Signals
signal interacted


# Vairables
export var player_has_choice = false

var _is_interactable := false
var choice_events : Array
var interact_events : Array


# Public
func interact(other) -> bool:
	# Just a public method for _interact(). Called by AI.
	return _interact(other)


# Private
func _update_event_reference():
	if get_parent().name in EventDB.db['interact']:
		interact_events = EventDB.db['interact'][get_parent().name]
	if get_parent().name in EventDB.db['choice']:
		choice_events = EventDB.db['choice'][get_parent().name]

func _can_be_interacted_by(other):
	# Must be overridden by the child script.
	# This will define constraints on what and how this can be intereacted.
	return true

func _interact(other):
	# Called by the other(?), passing themselves into the function.
	#
	# Currently always triggers one event on interaction...
	# needs to forward all events to some choice ui so player can choose
	# what events they want to trigger...
	_update_event_reference()
	
	if _can_be_interacted_by(other):
		var possible_ievents = []
		var possible_cevents = []
		var ctx = Context.new()
		
		ctx.setup(get_parent(), other)
		
		#  Handle interaction events
		for ievent in interact_events:
			if ievent.can_trigger_from(ctx):
				# Events with numbers are seen as series, and will check to see
				# if the previous series event has been seen. 
				# 
				# You can see this logic on EventResource.can_trigger_from(ctx).
				 possible_ievents.append(ievent)

		if !possible_ievents.empty():
			possible_ievents.shuffle() # shuffle for more random fun!
			possible_ievents.sort_custom(self, "_event_priority_cmp")
			
			yield(possible_ievents.front().trigger(ctx), "completed")
		
		# Then prod for choice events, if any are triggerable.
		# Currently, the previous interaction dialogue disappears when choices
		# come up. Figure out how to keep previous dialogue present...
		for cevent in choice_events:
			if cevent.can_trigger_from(ctx):
				possible_cevents.append(cevent)
			
		if !possible_cevents.empty():
			possible_cevents.shuffle() # shuffle for more random fun!
			possible_cevents.sort_custom(self, "_event_priority_cmp")

			if !player_has_choice:
				possible_cevents.front().trigger(ctx)
			else:
				var chosen = yield(UI.probe_player_choice(possible_cevents), "completed")
				chosen.trigger(ctx)

func _event_priority_cmp(a, b):
	return a.priority > b.priority

func _on_Area2D_input_event(viewport, event, shape_idx):
	# The way for the player to _interact().
	if event is InputEventMouseButton:
		if event.button_index == 1 and event.pressed:
			_interact(get_tree().get_current_scene().find_node("Player", true, false))





