extends StaticBody2D

var player_in_range = false

func _ready():
	$Area2D.connect("body_entered", Callable(self, "_on_Area2D_body_entered"))
	$Area2D.connect("body_exited", Callable(self, "_on_Area2D_body_exited"))
	add_to_group("interactable")

func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):
		player_in_range = true

func _on_Area2D_body_exited(body):
	if body.is_in_group("player"):
		player_in_range = false

func interact():
	if player_in_range:
		$AnimatedSprite2D.play("open")
		remove_from_group("interactable")
