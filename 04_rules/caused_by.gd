class_name EventRuleCausedBy
extends EventRule


func check(ctx : Context, args : Array) -> bool:
	var caused_by = args[0]
	return ctx.cause.name == caused_by
