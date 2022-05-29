extends EventRules

func _can_trigger_from(ctx:Array) -> bool:
	return false

func _before_trigger(ctx:Array) -> bool:
	return false
	
func _on_trigger(ctx:Array, dialogue:DialogueResource = null):
	DialogueManager.show_example_dialogue_balloon("main", dialogue)
	yield(DialogueManager, "dialogue_finished")
	
func _after_trigger(ctx:Array):
	return false
