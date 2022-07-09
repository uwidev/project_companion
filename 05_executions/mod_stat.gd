extends EventExecute
# Modifies the entity initiator's stats.
# 
# Syntax: mod_stat <pow|vit|agi|dis> <int>


func execute(ctx : Context, args : Array) -> void:
	var cause = ctx.cause
	var stat = args[0]
	var amount = args[1].to_int()
	match stat:
		"pow":
			cause.power += amount
		"vit":
			cause.vitality += amount
		"agi":
			cause.agility += amount
		"dis":
			cause.discipline += amount
		_:
			print("stat %s does not exist" % stat)
