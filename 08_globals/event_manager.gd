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


# Variables
var processing_events = false


# Public
func on_successful_event(ctx:Array):
	# To allow events to occur after events.
	#
	# cataches "event_finished" from events
	if !processing_events:
		processing_events = true
		var event_queue = []
		
		event_queue.append_array(_get_valid_events(ctx))

		while !event_queue.empty():
			event_queue.shuffle() # shuffle for more random fun!
			event_queue.sort_custom(self, "_event_priority_cmp")
			for e in event_queue:
				print(e.get_priority(), " ", e.get_full_name())
			
			var ev = event_queue.pop_front()
			
			ev.trigger(ctx)
			ctx = yield(ev, "event_finished")

			event_queue.append_array(_get_valid_events(ctx))

		processing_events = false


# Private
func _get_valid_events(ctx:Array) -> Array:
	var ret = []
	
	for event in EventDB.db["event"]:
		var ev = event.get_valid_event(ctx)
		if ev:
			ret.append(ev)
			
	return ret

func _event_priority_cmp(a, b):
	return a.get_priority() > b.get_priority()
