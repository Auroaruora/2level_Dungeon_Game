extends CharacterBody2D

@onready var sprite = $Sprite2D
#@onready var camera = $Camera2D
@onready var detection_area = $Area2D  # Reference to the detection area
@export var speed = 18  # Movement speed when chasing the player
@export var max_health: int = 100
var current_health: int
@onready var health_bar = $BatHealthbar  # Ensure the Bat has a ProgressBar node

var squash_speed = 10.0  # Controls how fast the squash effect happens
var squash_amount_x = 0.3  # How much to squash (30%)
var squash_amount_y = 0.1  # How much to squash (10%)
var time = 0.0  # Timer for oscillation
var player = null  # Store reference to player

func _ready():
#    camera.make_current()  # Ensure the camera follows the enemy
	detection_area.body_entered.connect(_on_player_entered)
	detection_area.body_exited.connect(_on_player_exited)
	current_health = max_health
	update_health_bar()

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


func _on_enemy_hitbox_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
		if body.is_in_group("player"):
			player = body
			attack_player()
			

# Function to attack the player
func attack_player():
	if player and player.global_position.distance_to(global_position) < 40:
		player.take_damage(10)  # Bat deals 10 damage
		
		
# Take Damage Function
func take_damage(amount):
	current_health -= amount
	if current_health <= 0:
		die()
		update_health_bar()

func update_health_bar():
	if health_bar:
		print("HealthBar - max:", max_health, " current:", current_health)
		health_bar.min_value = 0
		health_bar.max_value = max_health
		health_bar.value = current_health



func die():
	queue_free()  # Bat disappears


func _on_enemy_hitbox_body_shape_exited(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body == player:
		player = null
		velocity = Vector2.ZERO  
