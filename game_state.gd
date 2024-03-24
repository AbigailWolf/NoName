extends Node

var num_levels := 2
var current_level := 0

var game_scene := "res://levels/OneWorld.tscn"
var title_screen := "res://ui/title.tscn"
var next_scene := "res://levels/OneWorld.tscn"

func restart() -> void:
	current_level = 0
	get_tree().change_scene_to_file(title_screen)

func next_level() -> void:
	current_level += 1
	if current_level <= num_levels:
		get_tree().change_scene_to_file(next_scene)


