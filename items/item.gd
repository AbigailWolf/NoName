extends Area2D

class_name Item

signal picked_up

enum ItemType {
	CHERRY,
	GEM
}

var textures: Dictionary = {
	ItemType.CHERRY: "res://assets/sprites/cherry.png",
	ItemType.GEM: "res://assets/sprites/gem.png"
}

func init(type: ItemType, _position: Vector2) -> void:
	$Sprite2D.texture = load(textures[type])
	position = _position

func _on_body_entered(body: Node2D) -> void:
	picked_up.emit()
	queue_free()
