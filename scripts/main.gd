extends Node2D

signal gameover

func _ready():
	$audio_player.play(0)

func _on_level_gameover():
	get_tree().paused = true
	gameover.emit()
