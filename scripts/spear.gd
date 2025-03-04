extends Node2D

@export var bullet_speed: float = 500  # Speed of bullets
@export var bullet_lifetime: float = 2.0  # Bullet duration
@export var bullet_radius: float = 2.0  # Bullet size

var bullets = []  # Store active bullets

func _process(delta):
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
		shoot()

func shoot():
	var target_position = get_global_mouse_position()
	var direction = (target_position - global_position).normalized()

	# Create bullet data (no separate scene, just stored in an array)
	var bullet = {
		"position": global_position,  # Start at spear
		"direction": direction,
		"time_left": bullet_lifetime
	}
	bullets.append(bullet)

func _draw():
	# Draw bullets as circles
	for bullet in bullets:
		draw_circle(bullet["position"] - global_position, bullet_radius, Color.WHITE)
