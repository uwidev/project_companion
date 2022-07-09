extends Control


signal choice_chosen

onready var choices = $CanvasLayer/CenterContainer/Choices



func probe_player_choice(events:Array) -> EventResource:
	# Clear current choices
	Utility.remove_all_children(choices)
	
	# Populate UI button choices
	for ev in events:
		var button = Button.new()
		button.set_custom_minimum_size(Vector2(300, 50))
		button.theme = Utility.main_theme
		button.text = ev.alias
		if button.text == "":
			button.text = ev.name
		button.connect("pressed", self, "_on_choice_selected", [ev])
		
		choices.add_child(button)

	# Prompt player and wait for response
	choices.visible = true
	var choice = yield(self, "choice_chosen")
	
	# Hide choice and return event
	choices.visible = false
	return choice
	
func _on_choice_selected(choice):
	emit_signal("choice_chosen", choice)
