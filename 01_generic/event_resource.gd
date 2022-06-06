extends EventResourceBase

# Virutal
func _can_trigger_from(ctx:Array) -> bool:
	# Denotes any conditions that are specific to this event. This WILL and
	# SHOULD check _span_conditions(ctx) to make sure previous conditions also
	# return true (e.g. ensure the current day is always > 30).
	#
	# Returns true if context satisfies that this event can trigger.
	return true

func _before_trigger(ctx:Array):
	# Any setup that needs to be done before the actual event triggers.
	pass

func _on_trigger(ctx:Array):
	# The actual happening of the event, usually dialogue stuff.
	DialogueManager.show_example_dialogue_balloon("main", dialogue)
	yield(DialogueManager, "dialogue_finished")
	
func _after_trigger(ctx:Array):
	# Cleanup, usually modifying the initiator to let them know they've now
	# seen this event.
	ctx[0].add_seen(resource_name)
