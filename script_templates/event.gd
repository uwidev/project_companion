extends EventResource
# Describe this event here

# Exports for other resources go here


func _can_trigger_from(ctx:Array) -> bool:
	return false

func _before_trigger(ctx:Array) -> bool:
	return false
	
func _on_trigger(ctx:Array):
	DialogueManager.show_example_dialogue_balloon("dialogue_title_here", dialogue)
	yield(DialogueManager, "dialogue_finished")
	
func _after_trigger(ctx:Array):
	return false
