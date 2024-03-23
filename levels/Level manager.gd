extends Node2D

var level_number = 1
var screen_size = Vector2()
var is_switching_level = false

func _ready():
	screen_size = get_viewport_rect().size
	load_level(level_number)

func load_level(level):
	var level_path = "res://Level" + str(level) + ".tscn"
	var level_scene = load(level_path)
	var level_instance = level_scene.instantiate()
	add_child(level_instance)
	is_switching_level = false

func switch_level():
	if is_switching_level:
		return

	is_switching_level = true
	level_number += 1

	if level_number > 2:
		level_number = 1

	# Assuming the player node is named "Player"
	var player = get_node("Node2D/Player")

	if player:
		var player_position = player.position

		if player_position.x < 0:
			player.position.x = screen_size.x
		elif player_position.x > screen_size.x:
			player.position.x = 0
		elif player_position.y < 0:
			player.position.y = screen_size.y
		elif player_position.y > screen_size.y:
			player.position.y = 0

	get_node("Node2D").queue_free()
	load_level(level_number)

func _process(delta):
	# Check if the player crosses the screen boundary
	# Assuming the player node is named "Player"
	var player = get_node("Node2D/Player")

	if player:
		var player_position = player.position
		var condition1 = player_position.x < 0
		var condition2 = player_position.x > screen_size.x
		var condition3 = player_position.y < 0
		var condition4 = player_position.y > screen_size.y

		if condition1 or condition2 or condition3 or condition4 :
			switch_level()
