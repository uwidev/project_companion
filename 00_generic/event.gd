class_name EventResource
extends Resource
# All events are to inherit from this base class
#
# The interhetied child gdscript is to be paired to a event resources.
#
# HOW TO CREATE AN EVENT =====
# Create a script. Make sure it's Template is Event.
# Create a new Resource (not EventResource)
# Drag your created script to the resource.
# Save the resource.
# Modify the event as need through the script, etc.

# Other comments, To-Do =====
# Will dialogue always occur with events?
# And if so, it's functionality needs to be added to the base class.
# The functionality of always rolling for the chance of trigger also
#   needs to be taken into account.
# Oneshot is not taken into account either. It will need to reference some
#   gamestate context. Potentially use some unique ID and hash it, stored in 
#   some global dictionary.
# There may be some trouble on functionality on control w/ multiple events...

signal triggered
signal event_finished

export var name : String
export var active : bool
export var chance : float
export var oneshot : bool

export var dialogue : Resource

export var trigger_by_interaction : bool
export var by_object : PackedScene
export var trigger_by_time : bool
export var trigger_by_event : bool

var fire := true


func _init():
	yield(EventManager, "ready")
	connect("event_finished", EventManager, "on_successful_event")
	
#	if trigger_by_interaction:
#		if on_object_name == null:
#			assert(false, 'Event "%s" must have "On Object Name" defined when "Trigger By Interaction" is true.' % name)


func trigger(ctx:Array):
	if _can_trigger_from(ctx):
		_before_trigger(ctx)
		yield(_on_trigger(ctx), "completed")
		_after_trigger(ctx)
	ctx.append(name)

#	connect("event_finished", EventManager, "on_successful_event")
	emit_signal("event_finished", ctx)
	
func can_trigger_from(ctx:Array) -> bool:
	return _can_trigger_from(ctx)


func _can_trigger_from(ctx:Array) -> bool:
	# needs to be overloaded for specifying events triggered from certain
	# entities, to this entity
	return true

func _before_trigger(ctx:Array) -> bool:
	# need to always consider the chance, program it in
	return true

func _on_trigger(ctx:Array):
	return null
	
func _after_trigger(ctx:Array):
	return null
