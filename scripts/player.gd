extends CharacterBody2D

const speed = 100
var current_dir = "none"

func _ready():
	$AnimatedSprite2D.play("idle_front")
func _physics_process(delta):
	player_movement(delta)

func player_movement(delta):
	
	if Input.is_action_pressed("ui_right"):
		current_dir ="right"
		play_anim(1)
		velocity.x = speed
		velocity.y = 0
	elif Input.is_action_pressed("ui_left"):
		current_dir ="left"
		play_anim(1)
		velocity.x = -speed
		velocity.y = 0
	elif Input.is_action_pressed("ui_up"):
		current_dir ="up"
		play_anim(1)
		velocity.x = 0
		velocity.y = -speed
	elif Input.is_action_pressed("ui_down"):
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
