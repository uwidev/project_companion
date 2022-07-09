class_name EventExecuteDialogue
extends EventExecute
# Given a dialogue resource string, queries for it and runs it.
# 
# Syntax: dialogue <name> <title>


func execute(ctx : Context, args : Array) -> void:
	var dialogue_name = args[0]
	var title = args[1]
	var dialogue = DialogueDb.db[dialogue_name]
	DialogueManager.show_example_dialogue_balloon(title, dialogue)
	yield(DialogueManager, "dialogue_finished")
