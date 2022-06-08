class_name EventResource
extends Resource
# A base resource-based implementation of events. Real events will have to
# extend from this and override virtual functions.
#
# Events are standalone and currently, do NOT span data to other events. In
# other words, there are no series, and must be linked up manually or
# added through some other implementation.
#
# If the name of the event ends with a number, or END, it's assumed that this
# event is from a series, and will check if the previous event in the series
# has been seen. All starting  events in a series start at 1, incrementing up.
# The final event should append " END". 
#
# If an event is oneshot, it will check if this event is in ctx.cause's seen.


signal triggered
signal event_finished

enum TriggerMethod {INTERACT, EVENT}

export(bool) var active = true
export(String) var name
export(bool) var oneshot = true  # can only be seen by the ctx.cause once?
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
func trigger(ctx):
	DialogueManager.show_example_dialogue_balloon(title, dialogue)
	yield(DialogueManager, "dialogue_finished")
	
	ctx.event_stack.append(self)
	ctx.cause.add_seen(name)
#	ctx.initiator.add_seen(name)  # maybe we want the initiator to see the scene?
	emit_signal("event_finished", ctx)

	
func can_trigger_from(ctx) -> bool:
	# Checks if active
	if !active:
		return false
	
	# Checks for oneshot
	if oneshot:
		if ctx.cause.has_seen_event(self):
			return false
	
	# Check if event is a series
	if name.right(name.length()-1) == "1":
		if ctx.cause.has_seen(name.left(name.length()-1) + "END"):
			return false
	elif name.right(name.length()-1).is_valid_integer():
		var i = int(name.right(0)) - 1
		if !ctx.cause.has_seen(name.left(name.length()-1) + str(i)): 
			return false
	elif name.ends_with(" END"):
		var bname = name.rstrip(" END")
		var i = int(bname.right(bname.length()-1)) - 1
		if !ctx.cause.has_seen(bname.left(bname.length()-1) + str(i)): 
			return false
	
	# Rule checking
	for rule in rules:
		if rule is EventRule and rule.has_method("check"):
			if !(rule.check(ctx)):
				return false
	
	# If everything passes, then this event can trigger
	return true

func safe_trigger(ctx):
	if can_trigger_from(ctx):
		trigger(ctx)
