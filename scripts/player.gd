extends CharacterBody2D

# constants
const SPEED = 125.0
const DASH_SPEED = 300.0
const DASH_DURATION = 0.2
const JUMP_VELOCITY = -275.0

var is_dashing = false
var dash_timer = 0.0

# get default grav
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta: float) -> void:
	# add grav
	if not is_on_floor():
		velocity += get_gravity() * delta

	# jump input
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# dash input
	if Input.is_action_just_pressed("dash") and not is_dashing:
		start_dash()
		
	if is_dashing:
		dash_timer -= delta
		if dash_timer <= 0:
			is_dashing = false

	# horizontal input
	var direction = 0
	if Input.is_action_pressed("move_left"):
		direction -= 1
	if Input.is_action_pressed("move_right"):
		direction += 1
	
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

func start_dash():
	is_dashing = true
	dash_timer = DASH_DURATION
	var dash_direction = 1 if not $AnimatedSprite2D.flip_h else -1
	velocity.x = dash_direction * DASH_SPEED
	velocity.y = 0
