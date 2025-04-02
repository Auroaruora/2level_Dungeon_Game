extends Node2D

@export var item_name: String = "Key"

@onready var area = $Area2D

func _ready():
	# Connect signal manually in script
	area.body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		print("Key picked up")
		Inventory.add_item({
			"name": item_name,
			"icon": preload("res://assets/01.png")
		})
		queue_free()  # Now this removes the entire Key node!


func _on_area_2d_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
