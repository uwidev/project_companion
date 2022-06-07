class_name Context
extends Resource
# Context (ctx) is a class which contains useful information for determining
# the circumstances to trigger potential events.
#
# initator: Object
#   The Object that is calling for the potential event(s) to occur
# cause: Entity
#   If the event was interaction-based, then this will be the Entity that
#   interacted with the initiator. If event triggered from the world, e.g. a
#   change in time, this may be null, or "time", need to figure out.
# event_stack: [String]
#   The ongoing stack of events that have occured during this chain of events.

var initiator: Object
var cause: Entity
var event_stack: Array

func setup(i:Entity, c:Entity = null):
	initiator = i
	cause = c

