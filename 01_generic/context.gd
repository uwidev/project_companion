class_name Context
extends Resource
# Context (ctx) is a class which contains useful information for determining
# the circumstances to trigger potential events.
#
# initator: Anything
#   The object that is calling for the potential event(s) to occur
# cause: Entity?
#   If the event was interaction-based, then this will be the Entity that
#   interacted with the initiator. If event triggered from the world, e.g. a
#   change in time, this may be null, or "time", need to figure out.
# event_stack: [String]
#   The ongoing stack of events that have occured during this chain of events.

var initiator
var cause
var event_stack: Array

func setup(i, c = null):
	initiator = i
	cause = c

