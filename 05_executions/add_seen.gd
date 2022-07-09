class_name EventExecuteAddSeen
extends EventExecute
# Adds this event's name string to the entity initiator's (cause) seen array.
# 
# Syntax: add_seen

func execute(ctx : Context, args : Array) -> void:
	var event_name = ctx.event_stack.back().name
	ctx.cause.add_seen(event_name)
