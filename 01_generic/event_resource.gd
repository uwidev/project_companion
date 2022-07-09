class_name EventResource
extends Resource
# A base resource-based implementation of events. Real events will have to
# extend from this and override virtual functions.


signal triggered
signal event_finished

enum TriggerMethod {INTERACT, EVENT, CHOICE}

var can_trigger = true
var name : String
var alias : String
var oneshot = true  # can only be seen by the ctx.cause once?
var type : int
var rules_str : String
var priority := 0
var exec_str : String

var _rules : Array # of Rules
var _exec : Array # of executions


# Built-in
func _init():
	connect("event_finished", EventManager, "on_successful_event")

# Public
func trigger(ctx : Context):
	ctx.event_stack.append(self)
	
	for exec in _exec:
		# Index 0 is the function, index 1 is the arguments
		# Note that arguments will ALWAYS be in the form of a string. It is up
		# to the execution script to determine what to to with it.
		var f = exec[0].execute(ctx, exec[1]) 
		if f is GDScriptFunctionState and f.is_valid():  # For dealing with co-routines
			yield(f, "completed")
	
	emit_signal("event_finished", ctx)
	
func can_trigger_from(ctx) -> bool:
	# Events always have innate checking for event series.
	
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
		var bname = name.trim_suffix(" END")
		var i = int(bname.right(bname.length()-1)) - 1
		if !ctx.cause.has_seen(bname.left(bname.length()-1) + str(i)): 
			return false
	
	# Rule checking
	for rule in _rules:
		if rule is EventRule and rule.has_method("check"):
			if !(rule[0].check(ctx, rule[1])):
				return false
	
	# If everything passes, then this event can trigger
	return true

func safe_trigger(ctx):
	if can_trigger_from(ctx):
		trigger(ctx)

# Private
func parse_res(to_parse : String, ref_db) -> Array:
	# String Operations
	var ret = []
	
	var cleaned = to_parse.strip_edges().replace("\n", ";").strip_escapes().replace(" ", "_")
	var res_str_arr = cleaned.split(";")
	
	for res_str in res_str_arr:
		if not res_str in ref_db:
			push_warning("Resource " + res_str + " was not found in the database.")
		ret.append(ref_db[res_str])
		
	return ret

func _parse_res_arg(to_parse : String, ref_db) -> Array:
	# String Operations
	var ret = []
	
	var cleaned = to_parse.strip_edges().replace("\n", ";").strip_escapes()
	var res_str_arr = cleaned.split(";")
	
	# Create a new array, turning the element strings into arrays
	var func_arg_arr := []
	for statement in res_str_arr:
		func_arg_arr.append(statement.split(" ") as Array)
	
	# Grab the first element, which denotes what statement to run
	# The rest are just arguments to pass to the statement's execute function
	var func_arr_str := []
	for res in func_arg_arr:
		func_arr_str.append(res.pop_front())

	# Just setting it to a different variable for easier working with
	var arg_arr = func_arg_arr
	
	# Now grab the execution resource
	var func_arr := []
	for res_str in func_arr_str:
		if not res_str in ref_db:
			push_error("Resource " + res_str + " was not found in the database.")
		func_arr.append(ref_db[res_str])
		
	# Now zip everything
	for i in range(func_arr.size()):
		ret.append([func_arr[i], arg_arr[i]])
	
	return ret
	
#	DialogueManager.show_example_dialogue_balloon(title, dialogue)
#	yield(DialogueManager, "dialogue_finished")

#func _post(ctx) -> void:
#	# Seen
#	ctx.event_stack.append(self)
#	ctx.cause.add_seen(name)
##	ctx.initiator.add_seen(name)  # maybe we want the initiator to see the scene?
#
#	# Deal with time
##	if end_phase:
##		WorldState.end_phase()
##	else:
##		WorldState.advance_time(advance_time)
#
#	# Deal with modifying the ctx.cause's stats
##	ctx.cause.mod_comfort(comfort)
	
	
