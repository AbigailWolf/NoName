extends CharacterBody2D

var speed = 300

func _physics_process(delta):
	var input_dir = Vector2.ZERO

	if Input.is_action_pressed("Left"):
		input_dir.x -= 1

	if Input.is_action_pressed("Right"):
		input_dir.x += 1

	if Input.is_action_pressed("Jump"):
		input_dir.y -= 1

	velocity = input_dir.normalized() * speed
	move_and_collide(velocity * delta)
