class_name EventRuleJustTriggered
extends EventRule


export(Resource) var event #EventResource


func check(ctx:Context) -> bool:
	return ctx.event_stack.back() == event
