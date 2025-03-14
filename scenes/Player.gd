extends CharacterBody2D

@export var speed := 200
@export var jump_speed := -600
@export var gravity := 1200
@onready var animplayer = $AnimatedSprite2D


func _get_input():
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		velocity.y = jump_speed

	var direction = Input.get_axis("ui_left", "ui_right")
	if direction != 0:
		velocity.x = direction * speed
		animplayer.flip_h = direction < 0
		animplayer.play("walk right")
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		animplayer.play("idle")


func check_collision():
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		if collider.name == "NewPlayer":  # Use class_name check
			var knockback_direction = (collider.global_position - global_position).normalized()
			var knockback_dir = Vector2(sign(knockback_direction.x), 0)
			collider.pushed(knockback_dir)


func _physics_process(delta: float) -> void:
	_get_input()
	velocity.y += gravity * delta
	move_and_slide()
	check_collision()
