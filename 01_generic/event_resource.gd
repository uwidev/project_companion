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

export(bool) var can_trigger = true
export(bool) var oneshot = true  # can only be seen by the ctx.cause once?
export(int, "INTERACT", "EVENT") var type
export(Array, Resource) var rules

export(int, -9, 9) var priority := 0
export(Resource) var dialogue : Resource # DialogueResource
export(String) var title = "main"


var name  # assigned from EventDB on ready, matches the file name
#var advance_time : int
#var end_phase : bool
#var comfort : int
#var advance_time := 0
#var end_phase := false
#var adjust_comfort := 0

# Built-in
func _init():
	connect("event_finished", EventManager, "on_successful_event")
	
#	name = trigger_name
#	dialogue = run_dialogue
#	title = run_title
#	priority = run_priority
#	advance_time = post_advance_time
#	end_phase = post_end_phase
#	comfort = post_adjust_comfort

# # Has a problem where we cannot retain data whenever this script saves on 
# # error. I think this is just a matter of how exports work, and cannot be
# # avoided.
#func _get_property_list() -> Array:
#	var properties = []
#
#	properties.append({
#		name = "Trigger",
#		type = TYPE_NIL,
#		hint_string = "trigger_",
#		usage = PROPERTY_USAGE_GROUP | PROPERTY_USAGE_SCRIPT_VARIABLE
#	})
#	properties.append({
#		name = "trigger_active",
#		type = TYPE_BOOL
#	})
#	properties.append({
#		name = "trigger_name",
#		type = TYPE_STRING
#	})
#	properties.append({
#		name = "trigger_oneshot",
#		type = TYPE_BOOL
#	})
#	properties.append({
#		name = "trigger_type",
#		type = TYPE_INT,
#		hint = PROPERTY_HINT_ENUM,
#		hint_string = "INTERACT,EVENT"
#	})
#	properties.append({
#		name = "trigger_rules",
#		type = TYPE_ARRAY,
#		hint_string = "17:Resource"
#	})
#
#	properties.append({
#		name = "Execution",
#		type = TYPE_NIL,
#		hint_string = "run_",
#		usage = PROPERTY_USAGE_GROUP | PROPERTY_USAGE_SCRIPT_VARIABLE
#	})
#	properties.append({
#		name = "run_dialogue",
#		type = TYPE_OBJECT
#	})
#	properties.append({
#		name = "run_title",
#		type = TYPE_STRING
#	})
#	properties.append({
#		name = "run_priority",
#		type = TYPE_INT,
#		hint = PROPERTY_HINT_RANGE,
#		hint_string = "-3,3"
#	})
#
#	properties.append({
#		name = "Post",
#		type = TYPE_NIL,
#		hint_string = "post_",
#		usage = PROPERTY_USAGE_GROUP | PROPERTY_USAGE_SCRIPT_VARIABLE
#	})
#	properties.append({
#		name = "post_advance_time",
#		type = TYPE_INT
#	})
#	properties.append({
#		name = "post_end_phase",
#		type = TYPE_BOOL
#	})
#	properties.append({
#		name = "post_adjust_comfort",
#		type = TYPE_INT
#	})
#
#	return properties


# Public
func trigger(ctx):
	_execute(ctx)
	_post(ctx)
	
func can_trigger_from(ctx) -> bool:
	# Checks if active
	if !can_trigger:
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

# Private
func _execute(ctx) -> void:
	DialogueManager.show_example_dialogue_balloon(title, dialogue)
	yield(DialogueManager, "dialogue_finished")

func _post(ctx) -> void:
	# Seen
	ctx.event_stack.append(self)
	ctx.cause.add_seen(name)
#	ctx.initiator.add_seen(name)  # maybe we want the initiator to see the scene?

	# Deal with time
#	if end_phase:
#		WorldState.end_phase()
#	else:
#		WorldState.advance_time(advance_time)
		
	# Deal with modifying the ctx.cause's stats
#	ctx.cause.mod_comfort(comfort)
	
	emit_signal("event_finished", ctx)
