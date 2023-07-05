extends Node2D

var is_panning = false
@onready var camera = $Camera2D
@export var cam_spd = 10

var decay = 0.9
var max_offset = Vector2(100,75)
var max_roll = 0.1
var trauma = 0.0
var trauma_power = 2

func _ready():
	randomize()
	global_position = Vector2(800,400)
	camera.zoom = Vector2(1,1)
	camera.make_current()


func _process(delta):
	is_panning = Input.is_action_pressed("mb_right")
	if trauma:
		trauma = max(trauma - decay * delta, 0)
		shake()


func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == MOUSE_BUTTON_WHEEL_UP and camera.zoom < Vector2(2,2):
				camera.zoom += Vector2(0.1,0.1)
			if event.button_index == MOUSE_BUTTON_WHEEL_DOWN and camera.zoom > Vector2(0.4,0.4):
				camera.zoom -= Vector2(0.1,0.1)
	if(event is InputEventMouseMotion):
		if(is_panning):
			global_position -= event.relative
		# handle panning melebihi batas
		if camera.zoom.x > 0.7:
			global_position.x = 200 if global_position.x < 200 else global_position.x
		elif camera.zoom.x > 0.6:
			global_position.x = 380 if global_position.x < 380 else global_position.x
		elif camera.zoom.x > 0.5:
			global_position.x = 600 if global_position.x < 600 else global_position.x
		elif camera.zoom.x > 0.4:
			global_position.x = 920 if global_position.x < 920 else global_position.x
		elif camera.zoom.x > 0.3:
			global_position.x = 1400 if global_position.x < 1400 else global_position.x
		if global_position.x > 3400:
			global_position.x = 3400
			
		if camera.zoom.y > 0.7:
			global_position.y = 100 if global_position.y < 100 else global_position.y
		elif camera.zoom.y > 0.6:
			global_position.y = 280 if global_position.y < 280 else global_position.y
		elif camera.zoom.y > 0.5:
			global_position.y = 400 if global_position.y < 400 else global_position.y
		elif camera.zoom.y > 0.4:
			global_position.y = 580 if global_position.y < 580 else global_position.y
		elif camera.zoom.y > 0.3:
			global_position.y = 850 if global_position.y < 850 else global_position.y
		if global_position.y > 1400:
			global_position.y = 1400


func add_trauma(amount):
	trauma = min(trauma + amount, 0.5)


func shake():
	var amount = pow(trauma, trauma_power)
	camera.rotation = max_roll * amount * randf_range(-1, 1)
	camera.offset.x = max_offset.x * amount * randf_range(-1, 1)
	camera.offset.y = max_offset.y * amount * randf_range(-1, 1)


func _on_level_camera_shake():
	add_trauma(0.5)
