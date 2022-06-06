class_name EventRuleInitiatedBy
extends EventRule


export(String) var entity_name


func check(ctx:Context) -> bool:
	return ctx.initiator is Entity and ctx.initiator.name == entity_name
