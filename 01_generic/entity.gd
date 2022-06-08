class_name Entity
extends Node
# The class of all characters.
#
# It contains everything for characters to engage with the world.
#
# It does NOT contain instructions on how to behave.
# That will be controlled by the player's behavior or on AI.


export var is_player := false
var seen : Array


func move_to(location):
	# Given a location node, try to move this entity into it.
	#
	# location.can_move_into returns an array where the first element returns
	# whether movement is allowed here by this entity, the second element
	# returns the reason. If the first element is true, the second element
	# will be an empty string.
	var res = location.can_move_into(self)
	if res[0]:
		get_parent().remove_child(self)
		location.add_child(self)
		print("Moved into location %s" % location.name)
	else:
		print(res[1])

func interact_with(other):
	pass

func add_seen(ev:String):
	seen.append(ev)
	
func has_seen(ev:String) -> bool:
	return ev in seen

func add_seen_event(ev:EventResource):
	seen.append(ev.name)
	
func has_seen_event(ev:EventResource) -> bool:
	return ev.name in seen
