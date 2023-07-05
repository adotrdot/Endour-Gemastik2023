extends Node2D

@onready var sprite = $Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	var target_modulate = sprite.get_modulate()
	target_modulate.a = 0
	var tween = get_tree().create_tween()
	tween.tween_property(sprite, "scale", Vector2(1,1), 1)
	tween.parallel().tween_property(sprite, "modulate", target_modulate, 0.8)
	tween.tween_callback(queue_free)
