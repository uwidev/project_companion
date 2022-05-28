# A collection of items that represent a character resource. 
#
# Things that come to mind is the name of the character and their expressions.
# Perhaps here we could also include their stats?
extends Resource
class_name CharacterResource

export var name := "John Doe"
export var sprite : Dictionary
# string-sprite pair of expression:sprite
