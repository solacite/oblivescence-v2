extends CharacterBody2D

# constants
const SPEED = 300.0
const JUMP_VELOCITY = -450.0

# get default grav
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta: float) -> void:
	# add grav
	if not is_on_floor():
		velocity += get_gravity() * delta

	# jump input
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# horizontal input
	var direction := Input.get_axis("ui_left", "ui_right")
	
	# set horizontal velocity
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# i like to move it move it
	move_and_slide()
	
	# update character anim based on mvmt
	update_animations()

func update_animations():
	var animated_sprite = $AnimatedSprite2D
	
	# jump/fall
	if not is_on_floor():
		if velocity.y < 0:
			animated_sprite.play("jump")
		else:
			animated_sprite.play("fall")
	
	elif velocity.x != 0:
		animated_sprite.play("run")
		animated_sprite.flip_h = velocity.x < 0
		
	else:
		animated_sprite.play("idle")
