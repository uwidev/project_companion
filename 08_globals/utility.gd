extends Node

const EVENTS_DIR = "res://03_events/"
const RULES_DIR = "res://04_rules/"
const EXECUTIONS_DIR = "res://05_executions/"
const DIALOGUE_DIR = "res://06_dialogue/"


func path_res_ref(path : String, suffix : String = ".tres") -> Dictionary:
	var ret = {}
	
	var dir := Directory.new()
	if dir.open(path) != OK:
		return {}
	
	if dir.list_dir_begin() != OK:
		dir.list_dir_end()
		return {}
		
	# Populate rules_lookup
	var filename := dir.get_next()
	while filename != "":
		if filename.ends_with(suffix):
			ret[filename.trim_suffix(suffix)] = load(path.plus_file(filename))

		filename = dir.get_next()
	dir.list_dir_end()

	return ret


func path_gd_to_res_ref(path : String, suffix : String = ".gd") -> Dictionary:
	var ret = {}
	
	var dir := Directory.new()
	if dir.open(path) != OK:
		return {}
	
	if dir.list_dir_begin() != OK:
		dir.list_dir_end()
		return {}
		
	# Populate rules_lookup
	var filename := dir.get_next()
	while filename != "":
		if filename.ends_with(suffix):
			var gd = load(path.plus_file(filename)) as GDScript
			ret[filename.trim_suffix(suffix)] = gd.new()

		filename = dir.get_next()
	dir.list_dir_end()

	return ret
