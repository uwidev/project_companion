extends EventResource
# Describe this event here

# Exports for other resources go here


func _can_trigger_from(ctx:Array) -> bool:
	if name in ctx:
		return false
	if ctx.back() == "Test Event":
		return true
	return false

func _before_trigger(ctx:Array) -> bool:
	return true

func _on_trigger(ctx:Array):
	DialogueManager.show_example_dialogue_balloon("chain_event_demo", dialogue)
	yield(DialogueManager, "dialogue_finished")
	
func _after_trigger(ctx:Array):
	pass
