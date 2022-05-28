tool
class_name Location
extends Node
# Contains everything needed for a location to operate.


export var background : Texture


func _process(delta):
	$Background.texture = background


func get_objects() -> Array:
	return $Objects.get_children()
	
func get_entities() -> Array:
	return $Entities.get_children()

func move_into(entity:Entity):
	if can_move_into(entity):
		entity.get_parent().remove_child(entity)
		$Entities.add_child(entity)

func can_move_into(entity:Entity) -> Array:
	return _can_move_into(entity)


func _can_move_into(entity:Entity) -> Array:
	# Virtual, must define when entity is able to move in
	if entity.is_player:
		return [true, '']
	return [false, 'Only the player can move here.']
