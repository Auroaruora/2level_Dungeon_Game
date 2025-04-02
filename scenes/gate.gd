extends StaticBody2D

@export var required_item_name: String = "Key"
@export var dungeon_scene: String = "res://scenes/dungeon.tscn"

@onready var sprite := $GateSprite
@onready var area := $Area2D
@onready var collider := $CollisionShape2D  # This blocks the player

var is_open = false

func _ready():
	sprite.frame = 0  # Start closed
	area.body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.name != "Player":
		return

	if not is_open and Inventory.has_item(required_item_name):
		Inventory.remove_item(required_item_name)
		open_gate()
		await get_tree().create_timer(1.0).timeout  # Wait for animation
		call_deferred("_enter_next_scene")
	elif not is_open:
		print("You need a key!")

func open_gate():
	is_open = true
	print("Opening gate...")
	sprite.play("open")  # Your animation: frames 0 → 1 → 2
	collider.disabled = true  # Allow player to walk through

	# Optional: Inventory.remove_item(required_item_name)
	# Inventory.remove_item(required_item_name)

func _enter_next_scene():
	get_tree().change_scene_to_file(dungeon_scene)
