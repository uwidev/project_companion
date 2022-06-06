class_name EventResource
extends Resource
# A base resource-based implementation of events. Real events will have to
# extend from this and override virtual functions.
#
# Events are standalone and currently, do NOT span data to other events. In
# other words, there are no series, and must be linked up manually or
# added through some other implementation.

signal triggered
signal event_finished

enum TriggerMethod {Interact, Event}

export(String) var name
export(TriggerMethod) var trigger_by
export(Resource) var dialogue # DialogueResource
export(String) var title = "main"
export(int, -9, 9) var priority
export(Array, Resource) var rules


# Built-in
func _init():
	connect("event_finished", EventManager, "on_successful_event")
	pass


# Public
func trigger(ctx:Context):
	DialogueManager.show_example_dialogue_balloon(title, dialogue)
	yield(DialogueManager, "dialogue_finished")
	
	ctx.event_stack.append(self)
	emit_signal("event_finished", ctx)
	
func can_trigger_from(ctx:Context) -> bool:
	for rule in rules:
		if rule is EventRule and rule.has_method("check"):
			if !(rule.check(ctx)):
				return false
	return true

func safe_trigger(ctx:Context):
	if can_trigger_from(ctx):
		trigger(ctx)
