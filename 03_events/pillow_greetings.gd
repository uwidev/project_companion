extends EventResource

func _init():
	can_trigger = true
	name = "pillow_greeting"
	alias = ""
	oneshot = false
	type = TriggerMethod.INTERACT
	
	rules_str = """
			caused_by Player
			initiated_by Pillow
			"""
	
	priority = 0
	
	exec_str = """
			dialogue pillow_greetings main
			add_seen
			"""
			
	# Don't change anything below this point.
	_parse()

func _parse():
	_rules = _parse_res_arg(rules_str, RulesDb.db)
	_exec = _parse_res_arg(exec_str, ExecutionDb.db)
