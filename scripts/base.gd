extends Node

var title_screen_res = preload("res://scenes/title_screen.tscn")
var title_screen = null
var tutorial_screen_res = preload("res://scenes/tutorial_screen.tscn")
var tutorial_screen = null
var gameover_screen_res = preload("res://scenes/gameover_screen.tscn")
var gameover_screen = null
var main_res = preload("res://scenes/main.tscn")
var main = null

var tutorial = true


# Called when the node enters the scene tree for the first time.
func _ready():
	title_screen = title_screen_res.instantiate()
	add_child(title_screen)
	title_screen.connect("start", start_game)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func start_game():
	if title_screen != null:
		title_screen.queue_free()
		title_screen = null
	if tutorial_screen != null:
		tutorial_screen.queue_free()
		tutorial_screen = null
	if tutorial:
		tutorial_screen = tutorial_screen_res.instantiate()
		add_child(tutorial_screen)
		tutorial_screen.connect("tutorial_done", _on_tutorialfinish)
		tutorial = false
		return
	main = main_res.instantiate()
	add_child(main)
	main.connect("gameover", _on_gameover)

func _on_tutorialfinish():
	start_game()

func _on_gameover():
	gameover_screen = gameover_screen_res.instantiate()
	add_child(gameover_screen)
	gameover_screen.connect("retry", _on_retry)
	
func _on_retry():
	main.queue_free()
	gameover_screen.queue_free()
	get_tree().paused = false
	start_game()
