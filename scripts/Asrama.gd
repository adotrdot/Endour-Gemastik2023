extends Bangunan

var blue_variant = preload("res://assets/asrama/asrama-blue.png")
var green_variant = preload("res://assets/asrama/asrama-green.png")
var red_variant = preload("res://assets/asrama/asrama-red.png")
@onready var sprite = $Sprite2D

func init(pos : Vector2):
	siswa_count = 3
	posisi_gerbang = pos
	set_blue()

func set_blue():
	sprite.set_texture(blue_variant)
	
func set_green():
	sprite.set_texture(green_variant)
	
func set_red():
	sprite.set_texture(red_variant)


func respawn_siswa():
	await get_tree().create_timer(5).timeout
	siswa_count += 1
