extends Area2D

@export var bullet_speed: float = 500  # Speed of bullets
@export var bullet_lifetime: float = 2.0  # Bullet duration
@export var bullet_radius: float = 2.0  # Bullet size

var bullets = []  # Store active bullets
var player_in_range = false
var attached = false

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("body_exited", Callable(self, "_on_body_exited"))
	add_to_group("interactable")

func _on_body_entered(body):
	if body.is_in_group("player"):
		player_in_range = true

func _on_body_exited(body):
	if body.is_in_group("player"):
		player_in_range = false

func _process(delta):
	if attached:
		global_rotation = get_global_mouse_position().angle_to_point(global_position)
		# Make spear point to mouse
		look_at(get_global_mouse_position())

		# Move and update bullets
		for bullet in bullets:
			bullet["position"] += bullet["direction"] * bullet_speed * delta
			bullet["time_left"] -= delta

		# Remove bullets that have expired
		bullets = bullets.filter(func(b): return b["time_left"] > 0)

		# Redraw bullets
		queue_redraw()

func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		attack()

func attack():
	var spawn_pos = $SpawnPoint.global_position
	#var target_position = get_global_mouse_position()
	var direction = Vector2.RIGHT.rotated(global_rotation)

	# Create bullet data (no separate scene, just stored in an array)
	var bullet = {
		"position": spawn_pos,
		"direction": direction,
		"time_left": bullet_lifetime
	}
	bullets.append(bullet)

func interact():
	if player_in_range:
		var player = get_tree().get_nodes_in_group("player")[0]
		player.pickup_weapon(self)
		
func _draw():
	# Draw bullets as circles
	for bullet in bullets:
		var local_pos = to_local(bullet["position"])
		draw_circle(local_pos, bullet_radius, Color.WHITE)
