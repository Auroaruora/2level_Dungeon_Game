extends MarginContainer

@onready var ui: HBoxContainer = $uiContainer
@onready var textLabel : Label = $uiContainer/NinePatchRect/MarginContainer/HBoxContainer/textContainer/MarginContainer/text

func _process(delta: float) -> void:
	# Make ui appear once player reaches the chest
	if GlobalVariables.weapon_chest_reached == true and GlobalVariables.weapon_chest_finished == false:
		ui.visible = true
		textLabel.text = "Would you like to open the chest to get a new weapon? If Yes then your current weapon will be destroyed..."	
	else:
		ui.visible = false
	pass

func _on_yes_button_pressed() -> void:
	# Player chose to open the chest
	print("Yes Pressed to Open Chest")
	GlobalVariables.weapon_chest_yes = true
	GlobalVariables.weapon_chest_finished = true
	ui.visible = false

func _on_no_button_pressed() -> void:
	# Player not chose to open the chest
	print("No Pressed to Open Chest")
	GlobalVariables.weapon_chest_yes = false
	GlobalVariables.weapon_chest_finished = false
	GlobalVariables.weapon_chest_reached = false
	ui.visible = false
