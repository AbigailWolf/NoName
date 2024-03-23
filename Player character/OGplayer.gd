extends CharacterBody2D

class_name Player

@export var gravity := 750
@export var run_speed := 150
@export var jump_speed := -300
@export var max_jumps := 2
@export var double_jump_factor := 1.5
@export var climb_speed := 50

var jump_count := 0

var is_on_ladder := false

enum PlayerState {IDLE, RUN, JUMP, CLIMB, HURT, DEAD}

var state := PlayerState.IDLE

signal life_changed
signal died

var life := 3: set = set_life

func set_life(value: int) -> void:
	life = value
	life_changed.emit(life)
	if life <= 0:
		change_state(PlayerState.DEAD)

func _ready() -> void:
	change_state(PlayerState.IDLE)
	
func _physics_process(delta: float) -> void:
	if state != PlayerState.CLIMB:
		velocity.y += gravity * delta
	get_input()
	
	move_and_slide()

	if state == PlayerState.JUMP and is_on_floor():
		change_state(PlayerState.IDLE)
		jump_count = 0
		$Dust.emitting = true
		
	if state == PlayerState.JUMP and velocity.y > 0:
		$AnimationPlayer.play("jump_down")
		
	if state == PlayerState.HURT:
		return
	for i in get_slide_collision_count():
		var collision := get_slide_collision(i)
		if collision.get_collider().is_in_group("danger"):
			hurt()
		if collision.get_collider().is_in_group("enemies"):
			if position.y < collision.get_collider().position.y:
				collision.get_collider().take_damage()
				velocity.y = -200
			else:
				hurt()
	
func change_state(new_state: PlayerState) -> void:
	state = new_state
	match state:
		PlayerState.IDLE:
			$AnimationPlayer.play("idle")
		PlayerState.RUN:
			$AnimationPlayer.play("run")
		PlayerState.HURT:
			$HurtSound.play()
			$AnimationPlayer.play("hurt")
			velocity.y = -200
			velocity.x = -100 * sign(velocity.x)
			life -= 1
			await get_tree().create_timer(0.5).timeout
			change_state(PlayerState.IDLE)
		PlayerState.JUMP:
			$JumpSound.play()
			$AnimationPlayer.play("jump_up")
			jump_count = 1
		PlayerState.CLIMB:
			$AnimationPlayer.play("climb")
		PlayerState.DEAD:
			died.emit()
			hide()

func get_input() -> void:
	if state == PlayerState.HURT:
		return
		
	var right := Input.is_action_pressed("right")
	var left := Input.is_action_pressed("left")
	var jump := Input.is_action_just_pressed("jump")
	
	var up := Input.is_action_pressed("climb")
	var down := Input.is_action_pressed("crouch")
	
	# movement occurs in all states
	velocity.x = 0
	if right:
		velocity.x += run_speed
		$Sprite2D.flip_h = false
	if left:
		velocity.x -= run_speed
		$Sprite2D.flip_h = true
	if jump and state == PlayerState.JUMP and jump_count < max_jumps and jump_count > 0:
		$JumpSound.play()
		$AnimationPlayer.play("jump_up")
		velocity.y = jump_speed / double_jump_factor
		jump_count += 1
	# only allow jumping when on the ground
	if jump and is_on_floor():
		change_state(PlayerState.JUMP)
		velocity.y = jump_speed
	# IDLE transitions to RUN when moving
	if state == PlayerState.IDLE and velocity.x != 0:
		change_state(PlayerState.RUN)
	# RUN transitions to IDLE when standing still
	if state == PlayerState.RUN and velocity.x == 0:
		change_state(PlayerState.IDLE)
	# transtition to JUMP when in the air
	if state in [PlayerState.IDLE, PlayerState.RUN] and !is_on_floor():
		change_state(PlayerState.JUMP)
		
	if up and state != PlayerState.CLIMB and is_on_ladder:
		change_state(PlayerState.CLIMB)
		
	if state == PlayerState.CLIMB:
		if up:
			velocity.y = -climb_speed
			$AnimationPlayer.play("climb")
		elif down:
			velocity.y = climb_speed
			$AnimationPlayer.play("climb")
		else:
			velocity.y = 0
			$AnimationPlayer.stop()
	
	if state == PlayerState.CLIMB and not is_on_ladder:
		change_state(PlayerState.IDLE)

func reset(_position: Vector2):
	position = _position
	show()
	change_state(PlayerState.IDLE)
	life = 3

func hurt() -> void:
	if state != PlayerState.HURT:
		change_state(PlayerState.HURT)
