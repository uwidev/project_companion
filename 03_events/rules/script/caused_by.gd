class_name EventRuleCausedBy
extends EventRule


export(String) var object_name


func check(ctx:Context) -> bool:
	return ctx.cause.name == object_name
