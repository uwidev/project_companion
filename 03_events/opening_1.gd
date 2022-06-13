extends EventResource

func _init():
	can_trigger = true
	name = "opening_1"
	oneshot = true
	type = TriggerMethod.INTERACT
	
	rules_str = """
			caused_by Player
			initiated_by Pillow
			"""
	
	priority = 0
	
	exec_str = """
			dialogue opening opening_1
			add_seen
			"""
			
	# Don't change anything below this point.
	_parse()

func _parse():
	_rules = _parse_res_arg(rules_str, RulesDb.db)
	_exec = _parse_res_arg(exec_str, ExecutionDb.db)
