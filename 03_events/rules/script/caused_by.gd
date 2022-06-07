class_name EventRuleCausedBy
extends EventRule

export(String) var entity_name

func check(ctx:Context) -> bool:
	return ctx.cause is Entity and ctx.cause.name == entity_name
