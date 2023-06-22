extends Node2D

signal request_timeout

func _on_timer_timeout():
	request_timeout.emit()
