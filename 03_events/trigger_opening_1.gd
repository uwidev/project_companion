extends EventResource

func _init():
	can_trigger = true
	name = "trigger_opening_1"
	alias = ""
	oneshot = true
	type = TriggerMethod.EVENT
	
	rules_str = """
			caused_by Player
			"""
	
	priority = 0
	
	exec_str = """
			dialogue opening opening_3
			add_seen
			"""
	
	# Don't change anything below this point.
	_parse()

func _parse():
	_rules = _parse_res_arg(rules_str, RulesDb.db)
	_exec = _parse_res_arg(exec_str, ExecutionDb.db)
