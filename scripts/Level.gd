extends Node2D

var can_place = true
var mousepos = Vector2i()
@onready var tilemap = $TileMap

var _test_asrama = true
var _test_kampus = true

func _ready():
	pass


func _process(delta):
	if _test_asrama:
		if Input.is_action_just_pressed("test_place_asrama"):
			tilemap.place_asrama(Vector2(0,0))
			_test_asrama = false
	if Input.is_action_just_pressed("test_place_kampus"):
		tilemap.place_kampus(Vector2(800,800))
		_test_kampus = false
	
	mousepos = get_local_mouse_position()
	if can_place:
		if Input.is_action_pressed("mb_left"):
			tilemap.place_road(mousepos)
		elif Input.is_action_pressed("mb_right"):
			tilemap.remove_road(mousepos)
