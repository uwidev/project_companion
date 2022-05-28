extends Node
# Connects, sequences, and coordinates all of the events of the game to convey
# procedural meaning. Responsible for stuff like controlling that B goes after 
# A, and that during B, the player is to not have control, among other things.
#
# Context (ctx) contains the additional information that can be used to
# determine whether an event is to trigger or not.
#
# The first two elements are a String that denotes what the interactor, and the
# object being interacted with. Consecutive elements are event names.
#
# If the first two elements are the same, then... uh... idk. Will need to figure
# something out for events related to time.
#
# May need to create an entirely new class ctx.


func on_successful_interaction(ctx:Array):
	# All entities must connect to this function.
	#
	# catches signals "interacted" from interactables
	var events = ctx.back().events
	var event : EventResource 
	
	for ev in events:
		event = ev
		if ev.can_trigger_from(ctx):
			break
	
#	var event : EventResource = _pop_interaction_event(ctx)
	if event != null:
		event.trigger(ctx)

func on_successful_event(ctx:Array):
	# To allow events to occur after events.
	#
	# cataches "event_finished" from events
	var event : EventResource = _pop_event_event(ctx)
	if event != null:
		event.trigger(ctx)
	pass


#func _pop_interaction_event(ctx:Array):
#	var ret
#
##	print(EventDB.EventDB["Interaction"])
##	if !(ctx[1] in EventDB.EventDB["Interaction"]):
##		print("No interaction event for %s exists." % ctx[1])
##		return
#
#	var interaction_list : Array = EventDB.EventDB["Interaction"][ctx[1]]
#	for event in interaction_list:
#		var ev : EventResource = event
#		if ev.can_trigger_from(ctx):
#			ret = ev
#			break
#
#	return ret

func _pop_event_event(ctx:Array):
	var ret
	
	var event_list : Array = EventDB.EventDB["Event"]
	for ev in event_list:
		if ev.can_trigger_from(ctx):
			ret = ev
			break
	
	return ret
