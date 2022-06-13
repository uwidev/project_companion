class_name EventRuleRequiresEvent
extends EventRule


func check(ctx:Context, args : Array) -> bool:
	var event_name = args[0]
	return ctx.cause.has_seen_event_name(event_name)
