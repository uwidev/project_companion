extends Node
# Manages time
# All representation of time starts at 1, except dayweek, which starts at 0.

signal phase_advanced
signal day_advanced

enum DAYWEEK {MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY, SATURDAY, SUNDAY}

export var max_phase : int = 2

var day : int
var time : int
var dayweek : int

func _ready():
	time = 1
	day = 1
	dayweek = 1
#	print("Time is now %s" % time)

func advance_time():
	if time + 1 > max_phase:
		time = 1
		emit_signal("phase_advanced")
		_advance_day()		
	else:
		time += 1
		emit_signal("phase_advanced")
#	print("Time is now %s" % time)

func is_daytime() -> bool:
	return time < 4
	
func is_evening() -> bool:
	return !is_daytime()

func is_weekday() -> bool:
	return dayweek < 6

func is_weekend() -> bool:
	return !is_weekday()
	
func _advance_day():
	day += 1
#	print("Day is now %s" % day)
	_advance_dayweek()
	emit_signal("day_advanced")
	
func _advance_dayweek():
	if dayweek + 1 > 6:
		dayweek = 0
	else:
		dayweek += 1
#	print("Dayweek is now %s" % DAYWEEK.keys()[dayweek])
