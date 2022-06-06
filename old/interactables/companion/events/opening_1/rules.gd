extends EventResource
# Describe this event here

# Exports for other resources go here

func _can_trigger_from(ctx:Array) -> bool:
	if ctx[0] is Entity and ctx[0].is_player:
		if !ctx[0].has_seen(name):
			return true
	return false

func _before_trigger(ctx:Array) -> bool:
	return false
	
func _on_trigger(ctx:Array):
	DialogueManager.show_example_dialogue_balloon("main", dialogue)
	yield(DialogueManager, "dialogue_finished")
	
func _after_trigger(ctx:Array):
	ctx[0].add_seen(name)
	emit_signal("event_finished")
