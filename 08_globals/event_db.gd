extends Node

# All events are to be loaded and accessed on EventDB.
# EventDB is a dictionary, with additional dictionaries that further categorize
# events based on what trigger-type it follows.
#
# Interaction-triggers are further categorized based on the object
# that is being interacted
enum TriggerMethod {INTERACT, EVENT}

var db : Dictionary

signal references_updated


# Built-in
func _init():
	db["interact"] = {}
	db["event"] = []
	db["choice"] = {}
	
func _ready():
	_build_resource_db()


# Public


# Private
#func _csv_to_ev(path: String) -> void:
#	var file = File.new()
#	file.open(path, file.READ)
#
#	# Get Header
#	var header = []
#
#	if not file.eof_reached():
#		var elements = file.get_line().split(',') as PoolStringArray
#		elements.remove(0)
#		header = elements
#
#	# Populate dictionary
#	while not file.eof_reached():
#		var line = file.get_line()
#		if line == "":
#			continue
#
#		var elements = line.split(',') as PoolStringArray
#
#		var ev = elements[0]
#		elements.remove(0)
#		events_lookup[ev] = {}
#
#		for i in range(elements.size()):
#			var k = header[i]
#			var v = elements[i].strip_edges()
#			# Handling of data and setting it as a proper value here
#			match header[i]:
#				# Bool
#				"oneshot":
#					events_lookup[ev][k] = v == "TRUE"
#
#				# Int
#				'priority':
#					events_lookup[ev][k] = int(v)
#
#				# Type ENUM
#				'type':
#					events_lookup[ev][k] = TriggerMethod[v]
#
#				# Rules
#				'rules':
#					var rules = []
#					var rules_raw = v.split(';')
#					for rule in rules_raw:
#						rules.append(rules_lookup[rule])
#
#					events_lookup[ev][k] = rules
#
#				# Execution
#				'execution':
#					events_lookup[ev][k] = v


func _build_resource_db() -> void:
	var dir := Directory.new()
	if dir.open(Utility.EVENTS_DIR) != OK:
		return
		
	if dir.list_dir_begin() != OK:
		dir.list_dir_end()
		return

	# Populate db
	var filename := dir.get_next()
	while filename != "":
		if filename.ends_with(".gd"):
			# Instance the node and let it init itself
			var ev_script := load(Utility.EVENTS_DIR.plus_file(filename)) as GDScript
			var ev_res = ev_script.new()
			ev_res.name = filename.trim_suffix(".gd")
			
			match ev_res.type:
				ev_res.TriggerMethod.INTERACT:
					var rules = ev_res._rules
					for rule in rules:
						if rule[0] is EventRuleInitiatedBy:
							var ename = rule[1][0]
							if !(ename in db['interact']):
								db['interact'][ename] = []
							db['interact'][ename].append(ev_res)
							break
				
				ev_res.TriggerMethod.EVENT:
					db['event'].append(ev_res)
				
				ev_res.TriggerMethod.CHOICE:
					var rules = ev_res._rules
					for rule in rules:
						if rule[0] is EventRuleInitiatedBy:
							var ename = rule[1][0]
							if !(ename in db['choice']):
								db['choice'][ename] = []
							db['choice'][ename].append(ev_res)
							break
				
		filename = dir.get_next()
	dir.list_dir_end()

	emit_signal("references_updated")




#func _register_series(event: NodeEventRoot):
#	if event.trigger_by_interact:
#		if !(event.with in db["interact"]):
#			db["interact"][event.with] = []
#		db["interact"][event.with].append(event)
#
#	elif event.trigger_by_events:
#		db["event"].append(event)
