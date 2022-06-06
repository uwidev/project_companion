class_name NodeEventRoot
extends Node
# All consecutive events are considered a series, that is, the previous events
# must be seen by the entity before the next one is able to be seen. This is
# implemented by immediately returning on get_event_if_valid(), when the event
# conditions are satisfied.
#
# Triggers extend to the entirety of the series. If you ever need a series to
# have events triggered by interactables AND events, you'll have to modify
# EventDB's database to support it, among other things...
#
# A possible workaround is to create different series for one bigger series.
#
# The decision to make the root triggers span the rest of the events was for
# simplicity, and just to make a damn choice.
#
# For triggers, choose ONE OR THE OTHER.


# Variables
export(int, -9, 9) var priority
export var trigger_by_interact : bool
export var with : String
export var trigger_by_events : bool


# Public
func has_seen_series(other: Entity) -> bool:
	# Historical data "seen" is stored within entities as the following:
	# SceneRoot_ChildName
	#
	# They are stored sequentially, which is to say that if SceneRoot_END is
	# found in thier seen, it's assumed they have seen the entirety of this
	# event series.
	if name + "_END" in other.seen:
		return true
	return false

func get_valid_event(ctx:Array) -> NodeEvent:
	# Travels down the tree to return a valid NodeEvent, given the context.
	return get_child(0).get_event_if_valid(ctx)

func seen(ctx: Array) -> bool:
	return true

func get_priority() -> int:
	return priority

func get_series_name() -> String:
	return name


# Virutal
func _span_conditions(ctx) -> bool:
	print(get_instance_id())
	return true


# Private



