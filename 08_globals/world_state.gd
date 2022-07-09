extends Node
# Manages the world state, namely time.
# Time is represented as an int from 0 to time_in_day - 1. This is for easier
# working with progress bars.
#
# Progressing time always returns the actual time progressed. Advancing time
# when near the next phase will only actually progress to the end of the current
# phase, meaning, if the current time is 69 and we advance time by 20, time is
# actually progressed by 1, meaning 1 will be returned.
# 
# All representation of time starts at 1, except dayweek, which starts at 0.

signal time_advanced
signal phase_advanced
signal day_advanced

enum DAYWEEK {MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY, SATURDAY, SUNDAY}

const time_in_day := 100
const daytime_threshold := 70

var day : int
var time : int
var dayweek : int

func _ready():
	time = 0
	day = 1
	dayweek = 1
#	print("Time is now %s" % time)

func advance_time(amount:int, stop_at_next_phase:bool = true) -> int:
	var ret
	if time < daytime_threshold and time + amount >= daytime_threshold:
		if stop_at_next_phase:
			time = daytime_threshold
			emit_signal("phase_advanced")
			ret = daytime_threshold - time
		else:
			if time + amount >= time_in_day:
				time = 0
				emit_signal("phase_advanced")
				_advance_day()
				ret = time_in_day - time
			else:
				time += amount
				emit_signal("phase_advanced")
				ret = amount
	elif time + amount >= time_in_day:
		time = 0
		emit_signal("phase_advanced")
		_advance_day()
		ret = time_in_day - time
	else:
		time += amount
		ret = amount

	emit_signal("time_advanced")
	return ret
#	print("Time is now %s" % time)

func queue_advance_time(amount, stop_at_next_phase:bool = true) -> int:
	yield(EventManager, "event_stack_finished")
	return advance_time(amount, stop_at_next_phase)

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
