extends CharacterBody2D

@export var gravity: float = 980.0
@export var walk_speed: float = 300.0
@export var jump_speed: float = -420.0
@export var dash_speed: float = 900.0
@export var dash_duration: float = 0.2
@export var dash_press_interval: float = 0.2

var can_double_jump: bool = true
var dashing: bool = false
var last_left_press_time: float = 0.0
var last_right_press_time: float = 0.0


func _physics_process(delta: float) -> void:
	velocity.y += delta * gravity
	handle_jump()
	handle_dash()
	handle_walk()
	move_and_slide()


func handle_jump() -> void:
	if is_on_floor():
		if Input.is_action_just_pressed("ui_up"):
			velocity.y = jump_speed
		can_double_jump = true

	if not is_on_floor() and can_double_jump and Input.is_action_just_pressed("ui_up"):
		velocity.y = jump_speed
		can_double_jump = false


func handle_dash() -> void:
	if dashing:
		return

	var current_time = Time.get_ticks_msec() / 1000.0
	var direction = 0

	if Input.is_action_just_pressed("ui_left"):
		if current_time - last_left_press_time < dash_press_interval:
			direction = -1
		last_left_press_time = current_time

	if Input.is_action_just_pressed("ui_right"):
		if current_time - last_right_press_time < dash_press_interval:
			direction = 1
		last_right_press_time = current_time

	if direction != 0:
		start_dash(direction)


func start_dash(direction: int) -> void:
	dashing = true
	velocity.x = direction * dash_speed

	# Stop dash after a short time
	await get_tree().create_timer(dash_duration).timeout
	dashing = false


func handle_walk() -> void:
	if dashing:
		return

	if Input.is_action_pressed("ui_left"):
		velocity.x = -walk_speed
	elif Input.is_action_pressed("ui_right"):
		velocity.x = walk_speed
	else:
		velocity.x = 0
