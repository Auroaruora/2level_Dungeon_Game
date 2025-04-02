extends StaticBody2D

var player_in_range = false
var is_open = false

func _ready():
	$Area2D.connect("body_entered", Callable(self, "_on_Area2D_body_entered"))
	$Area2D.connect("body_exited", Callable(self, "_on_Area2D_body_exited"))
	add_to_group("interactable")

func _on_Area2D_body_entered(body):
	print("entered")
	if body.is_in_group("player"):
		# Triggers UI to appear
		if GlobalVariables.weapon_chest_reached == false:
			player_in_range = true
			GlobalVariables.weapon_chest_reached = true

func _on_Area2D_body_exited(body):
	if body.is_in_group("player"):
		# Allow the user to come back to the chest if they walk away
		if GlobalVariables.weapon_chest_finished == false:
			GlobalVariables.weapon_chest_reached = false
		player_in_range = false

func interact():
	if player_in_range and GlobalVariables.weapon_chest_yes:
		$AnimatedSprite2D.play("open")
		is_open = true
		drop_weapon()
		remove_from_group("interactable")

func drop_weapon():
	var sword_scene = preload("res://scenes/spear.tscn")
	var sword = sword_scene.instantiate()
	sword.global_position = global_position
	get_tree().current_scene.add_child(sword)
