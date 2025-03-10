extends CharacterBody2D

const speed = 100
var current_dir = "none"
var current_weapon = null
@export var max_health: int = 100
var current_health: int

@onready var health_bar = $HealthBar  # Make sure the health bar exists in the scene
@onready var attack_area = $player_hitbox

func _ready():
	$AnimatedSprite2D.play("idle_front")
	current_health = max_health
	update_health_bar()
	attack_area.area_entered.connect(on_attack_area_entered)
	
func _physics_process(delta):
	player_movement(delta)

func player_movement(delta):
	
	if Input.is_action_pressed("move_right"):
		current_dir ="right"
		play_anim(1)
		velocity.x = speed
		velocity.y = 0
	elif Input.is_action_pressed("move_left"):
		current_dir ="left"
		play_anim(1)
		velocity.x = -speed
		velocity.y = 0
	elif Input.is_action_pressed("move_up"):
		current_dir ="up"
		play_anim(1)
		velocity.x = 0
		velocity.y = -speed
	elif Input.is_action_pressed("move_down"):
		current_dir ="down"
		play_anim(1)
		velocity.x = 0
		velocity.y = speed
	else:
		play_anim(0)
		velocity.x=0
		velocity.y=0
	move_and_slide()

func play_anim(movement):
	var dir = current_dir
	var anim = $AnimatedSprite2D
	
	if dir == "right":
		anim.flip_h = false
		if movement ==1:
			anim.play("run_right")
		elif movement == 0:
			anim.play("idle_right")
	if dir == "left":
		anim.flip_h = true
		if movement ==1:
			anim.play("run_right")
		elif movement == 0:
			anim.play("idle_right")
	if dir == "up":
		anim.flip_h = false
		if movement ==1:
			anim.play("run_back")
		elif movement == 0:
			anim.play("idle_back")
	if dir == "down":
		anim.flip_h = false
		if movement ==1:
			anim.play("run_front")
		elif movement == 0:
			anim.play("idle_front")

func _input(event):
	if event is InputEventKey and event.pressed and event.keycode == KEY_E:
		for interactable in get_tree().get_nodes_in_group("interactable"):
			if interactable.player_in_range:
				interactable.interact()
				break

	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		attack()
		if current_weapon:
			current_weapon.attack()
				
func attack():
	attack_area.monitoring = true  # Activate hitbox for this frame
	await get_tree().create_timer(0.1).timeout  # Attack lasts 0.1 sec
	attack_area.monitoring = false

func on_attack_area_entered(area):
	print("Attack hit something:", area.name)  # Debugging: Check if it detects anything
	if area.name == "enemy_hitbox":  # Check if it's the bat's hitbox
		var bat = area.get_parent()
		if bat.has_method("take_damage"):  # Ensure bat has this function
			print("Hit bat! Dealing damage...")
			bat.take_damage(15)

func take_damage(amount):
	current_health -= amount
	if current_health <= 0:
		die()
	update_health_bar()

func update_health_bar():
	health_bar.value = current_health

func die():
	queue_free()
	
func _on_player_hitbox_body_entered(body: Node2D) -> void:
	if body.name == "EnemyHitbox":  # Check if it is the bat's hitbox
		var bat = body.owner  # Get the Bat node correctly
		if bat.has_method("take_damage"):  # Ensure the bat has this function
			print("Hit bat:", bat)
			bat.take_damage(15)
			
func pickup_weapon(weapon):
	if current_weapon:
		drop_weapon(current_weapon)
	current_weapon = weapon
	if weapon.get_parent():
		weapon.get_parent().remove_child(weapon)
	$WeaponSocket.add_child(weapon)
	weapon.position = Vector2.ZERO
	weapon.remove_from_group("interactable")
	weapon.attached = true

func drop_weapon(weapon):
	if weapon.get_parent():
		weapon.get_parent().remove_child(weapon)
	get_tree().current_scene.add_child(weapon)
	weapon.global_position = global_position + Vector2(0, 50)
	weapon.add_to_group("interactable")
	current_weapon = null
