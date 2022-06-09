class_name EventRuleInitiatedBy
extends EventRule


export(String) var object_name


func check(ctx:Context) -> bool:
	return ctx.initiator.name == object_name
