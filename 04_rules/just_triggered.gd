class_name EventRuleJustTriggered
extends EventRule


func check(ctx:Context, args : Array) -> bool:
	var event_name = args[0]
	return ctx.event_stack.back().name == event_name
