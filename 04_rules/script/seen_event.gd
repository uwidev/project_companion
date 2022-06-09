class_name EventRuleRequiresEvent
extends EventRule


export(Resource) var event #  EventResource


func check(ctx : Context) -> bool:
	return ctx.cause.has_seen_event(event)
