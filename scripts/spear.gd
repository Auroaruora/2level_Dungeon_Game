extends Area2D

@export var bullet_speed: float = 500  # Speed of bullets
@export var bullet_lifetime: float = 2.0  # Bullet duration

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

func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		attack()

func attack():
	var bullet_scene = preload("res://scenes/bullet.tscn")
	var bullet = bullet_scene.instantiate()
	
	bullet.global_position = $SpawnPoint.global_position
	bullet.direction = (get_global_mouse_position() - global_position).normalized()
	
	bullet.rotation = bullet.direction.angle()
	
	get_tree().current_scene.add_child(bullet)

func interact():
	if player_in_range:
		var player = get_tree().get_nodes_in_group("player")[0]
		player.pickup_weapon(self)
		
