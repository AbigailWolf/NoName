extends MarginContainer

class_name HUD

@onready var life_counter = $HBoxContainer/LifeCounter.get_children()

func update_life(value: int):
	for heart in life_counter.size():
		life_counter[heart].visible = value > heart
		
func update_score(value: int):
	$HBoxContainer/Score.text = str(value)
