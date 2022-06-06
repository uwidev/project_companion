class_name NodeEvent
extends Node
# An event in the form of a node. This node must be a child of another NodeEvent
# or the child of a NodeEventRoot. Name of this event is simply the name of the
# node.


signal triggered
signal event_finished

export var dialogue : Resource # DialogueResource

#export var trigger_by_interactable : bool
#export var interactable : PackedScene
#export var trigger_by_events : bool


# Built-in
func _init():
	connect("event_finished", EventManager, "on_successful_event")
	pass


# Public
func trigger(ctx:Array):
	_before_trigger(ctx)
	yield(_on_trigger(ctx), "completed")
	_after_trigger(ctx)
	
	ctx.append(get_full_name()) # currently, we only check the name of the event
	emit_signal("event_finished", ctx)
	
func get_series_name() -> String:
	return get_parent().get_series_name()
	
func get_full_name() -> String:
	return get_series_name() + "_" + name

func seen(ctx: Array) -> bool:
	return get_full_name() in ctx[0].seen

func get_event_if_valid(ctx: Array) -> NodeEvent:
	if _can_trigger_from(ctx):
		return self
	elif !(get_child_count()):
		return null
		
	return get_child(0).get_event_if_valid(ctx)

func get_priority() -> int:
	return get_parent().get_priority()


# Virtual Functions
func _span_conditions(ctx) -> bool:
	return get_parent()._persist(ctx)

func _can_trigger_from(ctx:Array) -> bool:
	return get_parent()._persist(ctx) and true

func _before_trigger(ctx:Array) :
	return true

func _on_trigger(ctx:Array):
	return null

func _after_trigger(ctx:Array):
	return null


# Private
func _register():
	pass

func _from(ctx:Array):
	return ctx[0]
	
func _with(ctx:Array):
	return ctx[1]
	
