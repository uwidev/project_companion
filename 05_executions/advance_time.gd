class_name EventExecuteAdvanceTime
extends EventExecute
# Advances the game world by a certain amonut.
#
# Syntax: advance_time <amount> [stop_at_next_phase:bool = true]

func execute(ctx : Context, args : Array) -> void:
	var time = (args[0] as String).to_int()
	var stop = null
	if args.size() == 2:
		stop = bool(args[1])
	else:
		stop = true
	
	WorldState.queue_advance_time(time, stop)
