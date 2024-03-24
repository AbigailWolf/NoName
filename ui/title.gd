extends Control

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_select"):
		GameState.next_level()


signal level_changed(level_name)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _ready():
	$VBoxContainer/Button.grab_focus()


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://levels/level_01.tscn")

func _on_button_3_pressed():
	get_tree().quit()
