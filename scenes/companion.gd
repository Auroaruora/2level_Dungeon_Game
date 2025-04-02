extends CharacterBody2D

const speed = 100
var current_dir = "none"
var current_weapon = null

@onready var attack_area = $player_hitbox
@onready var navigation_agent = $NavigationAgent2D
@export var target : Node2D

func _ready():
	$AnimatedSprite2D.play("idle_front")
	attack_area.area_entered.connect(on_attack_area_entered)
	call_deferred("setup")
	pass
	
func setup():
	await get_tree().physics_frame
	# Get target position
	if target:
		navigation_agent.target_position = target.global_position
		
	var spear_scene = preload("res://scenes/spear.tscn")
	var spear = spear_scene.instantiate()
	spear.global_position = global_position
	get_tree().current_scene.add_child(spear)
	pickup_weapon(spear)
	
func _physics_process(delta):
	player_movement(delta)

func player_movement(delta):
	# Update target position
	if target:
		navigation_agent.target_position = target.global_position
	
	# Stop navigating if close enough
	if navigation_agent.is_navigation_finished():
		velocity = Vector2i.ZERO
		play_anim()
		return
	
	# Update navigation path
	var current_agent_position = global_position
	var next_path_position = navigation_agent.get_next_path_position()
	velocity = current_agent_position.direction_to(next_path_position) * speed
		
	# Determine direction for animation
	if velocity.x > 0 && velocity.y > -10 && velocity.y < 10:
		current_dir ="right"
	elif velocity.x < 0 && velocity.y > -10 && velocity.y < 10:
		current_dir ="left"
	elif velocity.y < 0:
		current_dir ="up"
	elif velocity.y > 0:
		current_dir ="down"
		
	# Move
	play_anim()
	move_and_slide()

func play_anim():
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

func pickup_weapon(weapon):
	current_weapon = weapon
	if weapon.get_parent():
		weapon.get_parent().remove_child(weapon)
	$WeaponSocket.add_child(weapon)
	weapon.position = Vector2.ZERO
	weapon.remove_from_group("interactable")
	weapon.attached = true
