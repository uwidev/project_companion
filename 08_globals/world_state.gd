extends Node
# Manages time
# All representation of time starts at 1, except dayweek, which starts at 0.

signal phase_advanced
signal day_advanced

enum DAYWEEK {MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY, SATURDAY, SUNDAY}

var time_in_day := 100
var daytime_threshold := 70

var day : int
var time : int
var dayweek : int

func _ready():
	time = 0
	day = 1
	dayweek = 1
#	print("Time is now %s" % time)

func advance_time(amount : int) -> void:
	if time < daytime_threshold and time + amount >= daytime_threshold:
		time = 70
		emit_signal("phase_advanced")
	elif time + amount >= time_in_day:
		time = 0
		emit_signal("phase_advanced")
		_advance_day()		
	else:
		time += amount
#	print("Time is now %s" % time)

func end_phase() -> void:
	emit_signal("phase_advanced")
	if time < daytime_threshold:
		time = 70
	else:
		_advance_day()
		time = 0
#	print("Time is now %s" % time)

func is_daytime() -> bool:
	return time < daytime_threshold
	
func is_evening() -> bool:
	return !is_daytime()

func is_weekday() -> bool:
	return dayweek < 6

func is_weekend() -> bool:
	return !is_weekday()
	
func _advance_day():
	day += 1
	_advance_dayweek()
	emit_signal("day_advanced")
	
func _advance_dayweek():
	if dayweek + 1 > 6:
		dayweek = 0
	else:
		dayweek += 1
#	print("Dayweek is now %s" % DAYWEEK.keys()[dayweek])
