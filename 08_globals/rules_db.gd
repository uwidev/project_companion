extends Node


var db = {}


func _init():
	db = Utility.path_gd_to_res_ref(Utility.RULES_DIR)
