extends CharacterBody2D

@export var gravity := 1200
@export var knockback_strength := 350
@export var friction := 1000
var is_knocked: bool = false


func pushed(direction: Vector2) -> void:
	if is_knocked:
		return

	velocity = direction * knockback_strength

	$AnimatedSprite2D.flip_h = direction.x > 0
	$AnimatedSprite2D.play("pushed")
	$AudioStreamPlayer2D.play()
	is_knocked = true

	await get_tree().create_timer(0.5).timeout
	$AnimatedSprite2D.play("idle")
	is_knocked = false


func _physics_process(delta: float) -> void:
	velocity.y += gravity * delta

	if is_knocked:
		velocity.x = move_toward(velocity.x, 0, friction * delta)

	move_and_slide()
