extends Area2D

var speed = 500
var direction = Vector2.RIGHT
var damage = 15
var bullet_color = Color.RED
var bullet_radius = 1.5

func _ready():
	area_entered.connect(_on_area_entered)
	$Lifetime.start(2.0)
	queue_redraw()

func _physics_process(delta):
	position += direction * speed * delta

func _on_area_entered(area):
	if area.is_in_group("enemy_hitbox"):
		if area.get_parent().has_method("take_damage"):
			area.get_parent().take_damage(damage)
		queue_free()

func _on_lifetime_timeout():
	queue_free()

func _draw():
	var collision_radius = $CollisionShape2D.shape.radius
	draw_circle(Vector2.ZERO, bullet_radius, bullet_color)
