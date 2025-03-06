extends Area2D

const DUNGEON_SCENE_PATH := "res://scenes/dungeon.tscn"

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	if body.name == "Player":
		call_deferred("_change_scene")

func _change_scene() -> void:
	get_tree().change_scene_to_file(DUNGEON_SCENE_PATH)
