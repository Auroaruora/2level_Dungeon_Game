extends CharacterBody2D

@onready var sprite = $Sprite2D
#@onready var camera = $Camera2D
@onready var detection_area = $Area2D  # Reference to the detection area
@export var speed = 18  # Movement speed when chasing the player

var squash_speed = 10.0  # Controls how fast the squash effect happens
var squash_amount_x = 0.3  # How much to squash (30%)
var squash_amount_y = 0.1  # How much to squash (10%)
var time = 0.0  # Timer for oscillation
var player = null  # Store reference to player

func _ready():
#    camera.make_current()  # Ensure the camera follows the enemy
	detection_area.body_entered.connect(_on_player_entered)
	detection_area.body_exited.connect(_on_player_exited)

func _process(delta):
	time += delta * squash_speed
	var squash_factor_x = sin(time) * squash_amount_x
	var squash_factor_y = sin(time) * squash_amount_y
	
	sprite.scale = Vector2(1.0 + squash_factor_x, 1.0 - squash_factor_y)  # Squash effect

	if player:  # If player detected, fly towards them
		var direction = (player.global_position - global_position).normalized()
		velocity = direction * speed
		move_and_slide()

# When the player enters detection range
func _on_player_entered(body):
	if body.is_in_group("player"):  # Ensure player has a "player" group
		player = body

# When the player leaves detection range
func _on_player_exited(body):
	if body == player:
		player = null
		velocity = Vector2.ZERO  # Stop moving
