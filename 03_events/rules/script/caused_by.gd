class_name EventRuleCausedBy
extends EventRule


func check(ctx:Context) -> bool:
	return ctx.cause is Entity and ctx.cause.is_player
