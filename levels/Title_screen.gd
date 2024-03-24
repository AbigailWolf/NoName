extends Control

signal level_changed(level_name)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _ready():
	$VBoxContainer/Button.grab_focus()


func _on_button_pressed() -> void:
	print ("beep")
	get_tree().change_scene("res://levels/level_01.tscn")

func _on_button_3_pressed():
	get_tree().quit()
