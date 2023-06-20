extends Node2D

@onready var siswa1 = $Siswa
@onready var siswa2 = $Siswa2

var start_point = Vector2i(4,3)
var end_point = Vector2i(19,6)

# Called when the node enters the scene tree for the first time.
func _ready():
	siswa1.set_path(start_point, end_point)
	siswa2.set_path(end_point, start_point)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
