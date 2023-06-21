extends Node2D

var is_panning = false
@onready var camera = $Camera2D
@export var cam_spd = 10

func _ready():
	camera.make_current()


func _process(delta):
	is_panning = Input.is_action_pressed("mb_mid")


func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == MOUSE_BUTTON_WHEEL_UP and camera.zoom < Vector2(2,2):
				camera.zoom += Vector2(0.1,0.1)
			if event.button_index == MOUSE_BUTTON_WHEEL_DOWN and camera.zoom > Vector2(0.5,0.5):
				camera.zoom -= Vector2(0.1,0.1)
	if(event is InputEventMouseMotion):
		if(is_panning):
			global_position -= event.relative
		# handle panning melebihi batas
		if global_position.x < 200:
			global_position.x = 200
		if global_position.y < 100:
			global_position.y = 100
