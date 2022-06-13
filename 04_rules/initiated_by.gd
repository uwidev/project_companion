class_name EventRuleInitiatedBy
extends EventRule


func check(ctx : Context, args : Array) -> bool:
	var initiated_by = args[0]
	return ctx.cause.name == initiated_by
