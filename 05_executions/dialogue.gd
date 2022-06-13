class_name EventExecuteDialogue
extends EventExecute

func execute(ctx : Context, args : Array) -> void:
	var dialogue_name = args[0]
	var title = args[1]
	var dialogue = DialogueDb.db[dialogue_name]
	DialogueManager.show_example_dialogue_balloon(title, dialogue)
	yield(DialogueManager, "dialogue_finished")
