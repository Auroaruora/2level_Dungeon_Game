extends CharacterBody2D

const speed = 100
var current_dir = "none"
var current_weapon = null
@export var max_health: int = 100
var current_health: int

var respawn_position: Vector2 = Vector2(-15, 420)
var is_dead = false  # Prevent double damage or actions while dead

@onready var health_bar = $PlayerHealthbar  # Make sure the health bar exists in the scene
@onready var attack_area = $player_hitbox

func _ready():
	
	$AnimatedSprite2D.play("idle_front")
	current_health = max_health
	update_health_bar()
	attack_area.area_entered.connect(on_attack_area_entered)
	
func _physics_process(delta):
	if is_dead:
		return
	player_movement(delta)

func player_movement(_delta):
	var input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = input_direction * speed
	
	if Input.is_action_pressed("move_right"):
		current_dir ="right"
	elif Input.is_action_pressed("move_left"):
		current_dir ="left"
	elif Input.is_action_pressed("move_up"):
		current_dir ="up"
	elif Input.is_action_pressed("move_down"):
		current_dir ="down"
	play_anim()
	move_and_slide()

func play_anim():
	if is_dead:
		return 
		
	var anim = $AnimatedSprite2D
		
	if current_dir == "right":
		anim.flip_h = false
		if velocity == Vector2.ZERO:
			anim.play("idle_right")
		else:
			anim.play("run_right")
	if current_dir == "left":
		anim.flip_h = true
		if velocity == Vector2.ZERO:
			anim.play("idle_right")
		else:
			anim.play("run_right")
	if current_dir == "up":
		anim.flip_h = false
		if velocity == Vector2.ZERO:
			anim.play("idle_back")
		else:
			anim.play("run_back")
	if current_dir == "down":
		anim.flip_h = false
		if velocity == Vector2.ZERO:
			anim.play("idle_front")
		else:
			anim.play("run_front")

func _input(event):
	# Trigger interaction when agreeing to open chest or on E key
	if (event is InputEventKey and event.pressed and event.keycode == KEY_E) \
		or GlobalVariables.weapon_chest_yes:
		for interactable in get_tree().get_nodes_in_group("interactable"):
			if interactable.player_in_range:
				interactable.interact()
				break

	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if current_weapon:
			attack()
			current_weapon.attack()
				
func attack():
	attack_area.monitoring = true  # Activate hitbox for this frame
	await get_tree().create_timer(0.1).timeout  # Attack lasts 0.1 sec
	attack_area.monitoring = false

func on_attack_area_entered(area):
	if area.name == "enemy_hitbox":  # Check if it's the bat's hitbox
		var bat = area.get_parent()
		if bat.has_method("take_damage"):  # Ensure bat has this function
			bat.take_damage(15)
			print("Bat took damage")

func take_damage(amount):
	if is_dead:
		return
	current_health -= amount
	if current_health <= 0:
		die()
	update_health_bar()

func update_health_bar():
	if health_bar:
		health_bar.max_value = max_health
		health_bar.value = current_health

func play_death_animation():
	var anim = $AnimatedSprite2D
	print("Playing death animation. Direction:", current_dir)

	match current_dir:
		"up":
			anim.flip_h = false
			anim.play("die_back")
		"down":
			anim.flip_h = false
			anim.play("die_front")
		"left":
			anim.flip_h = true
			anim.play("die_right")
		"right":
			anim.flip_h = false
			anim.play("die_right")


func die():
	is_dead = true
	velocity = Vector2.ZERO
	play_death_animation()

	await get_tree().create_timer(2.0).timeout  # Wait for animation duration
	global_position = respawn_position
	current_health = max_health
	update_health_bar()
	is_dead = false
	$AnimatedSprite2D.play("idle_front")


	
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
	#get_tree().current_scene.remove_child(weapon)
	weapon.global_position = global_position + Vector2(0, 50)
	# Do not allow swap between weapons after choosing one
	# weapon.add_to_group("interactable")
	current_weapon = null
	weapon.attached = false
