class_name EventExecuteAddSeen
extends EventExecute

func execute(ctx : Context, args : Array) -> void:
	var event_name = ctx.event_stack.back().name
	ctx.cause.add_seen(event_name)
