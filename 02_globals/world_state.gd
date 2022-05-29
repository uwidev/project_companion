extends Node
# Manages time


signal phase_advanced
signal day_advanced

export var max_phase : int = 3

var day : int
var time : int

var node_1 : Node


func _ready():
	time = 1
	day = 1

func advance_time():
	var old = time
	var a = day
	if time + 1 > max_phase:
		time = 0
		emit_signal("phase_advanced")
		day += 1
		emit_signal("day_advanced")
		
	else:
		time += 1
		print("Time is now %s" % time)
		emit_signal("phase_advanced")
