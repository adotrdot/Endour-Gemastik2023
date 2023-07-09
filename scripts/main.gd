extends Node2D

signal gameover

func _on_level_gameover():
	get_tree().paused = true
	gameover.emit()
