extends EventResource
# A showcase of event functionality


func _can_trigger_from(ctx:Array) -> bool:
	if ctx[0] == "Player" and ctx[1] == "B":
		return true
	return false

func _before_trigger(ctx:Array) -> bool:
#	print("Before trigger on %s" % name)
	return true
	
func _on_trigger(ctx:Array):
#	print("On Trigger on %s" % name)
	DialogueManager.show_example_dialogue_balloon("this_is_a_node_title", dialogue)
	yield(DialogueManager, "dialogue_finished")
	
func _after_trigger(ctx:Array):
#	print("After Trigger on %s" % name)
	pass
