extends Bangunan

var blue_variant = preload("res://assets/asrama/asrama-blue.png")
var green_variant = preload("res://assets/asrama/asrama-green.png")
var red_variant = preload("res://assets/asrama/asrama-red.png")
@onready var sprite = $Sprite2D

var spawn_point = PackedVector2Array()

func init(pos : Array):
	siswa_count = 3
	posisi_gerbang = pos.pop_front()
	posisi_gerbang_global = pos.pop_front()
	for point in pos:
		spawn_point.append(point)
	var tween = get_tree().create_tween()
	tween.tween_property(sprite, "scale", Vector2(1,1), 0.5).set_trans(Tween.TRANS_BOUNCE)

func set_blue():
	sprite.set_texture(blue_variant)
	
func set_green():
	sprite.set_texture(green_variant)
	
func set_red():
	sprite.set_texture(red_variant)


func respawn_siswa():
	await get_tree().create_timer(5).timeout
	siswa_count += 1
