extends Node2D


@onready var audio = $"audio-player"
var sfx_place = preload("res://assets/audio/sfx-place_road.wav")
var sfx_remove = preload("res://assets/audio/sfx-remove_road.wav")

@onready var sprite = $Sprite2D
@onready var clickable = $clickable
@onready var tilemap = get_node("../TileMap")
@onready var level = get_node("../../Level")
var posisi_tile = Vector2i()
var left = null
var right = null
var top = null
var bottom = null
var deleteable = true
var delete_process = false


func _ready():
	audio.set_stream(sfx_place)
	audio.play(0)
	sprite.set_texture(BaseJalan.res_single)
	var tween = get_tree().create_tween()
	tween.tween_property(sprite, "scale", Vector2(1,1), 0.2).set_trans(Tween.TRANS_BOUNCE)


func _process(delta):
	if delete_process:
		var list_siswa = Lists.siswa.duplicate()
		for siswa in list_siswa:
			for point in siswa.path_berangkat:
				if point == position:
					return
			for point in siswa.path_pulang:
				if point == position:
					return
		audio.set_stream(sfx_remove)
		audio.play(0)
		var tween = get_tree().create_tween()
		tween.tween_property(sprite, "scale", Vector2(), 0.2).set_trans(Tween.TRANS_BOUNCE)
		tween.tween_callback(self.queue_free)
		delete_process = false


# cek koneksi jalan dan refresh sprite
func refresh():
	match tilemap.get_cell_atlas_coords(0, posisi_tile):
		BaseJalan.coords.SINGLE:
			sprite.set_texture(BaseJalan.res_single)
		BaseJalan.coords.VERTICAL_TOP:
			sprite.set_texture(BaseJalan.res_vertical_top)
		BaseJalan.coords.VERTICAL_MID:
			sprite.set_texture(BaseJalan.res_vertical_mid)
		BaseJalan.coords.VERTICAL_BOT:
			sprite.set_texture(BaseJalan.res_vertical_bot)
		BaseJalan.coords.HORIZONTAL_LEFT:
			sprite.set_texture(BaseJalan.res_horizontal_left)
		BaseJalan.coords.HORIZONTAL_MID:
			sprite.set_texture(BaseJalan.res_horizontal_mid)
		BaseJalan.coords.HORIZONTAL_RIGHT:
			sprite.set_texture(BaseJalan.res_horizontal_right)
		BaseJalan.coords.JUNCTION_TOPLEFT:
			sprite.set_texture(BaseJalan.res_junction_topleft)
		BaseJalan.coords.JUNCTION_TOPMID:
			sprite.set_texture(BaseJalan.res_junction_topmid)
		BaseJalan.coords.JUNCTION_TOPRIGHT:
			sprite.set_texture(BaseJalan.res_junction_topright)
		BaseJalan.coords.JUNCTION_MIDLEFT:
			sprite.set_texture(BaseJalan.res_junction_midleft)
		BaseJalan.coords.JUNCTION_MIDMID:
			sprite.set_texture(BaseJalan.res_junction_midmid)
		BaseJalan.coords.JUNCTION_MIDRIGHT:
			sprite.set_texture(BaseJalan.res_junction_midright)
		BaseJalan.coords.JUNCTION_BOTLEFT:
			sprite.set_texture(BaseJalan.res_junction_botleft)
		BaseJalan.coords.JUNCTION_BOTMID:
			sprite.set_texture(BaseJalan.res_junction_botmid)
		BaseJalan.coords.JUNCTION_BOTRIGHT:
			sprite.set_texture(BaseJalan.res_junction_botright)


# deteksi klik kanan mouse untuk menghapus jalan
func _on_clickable_input_event(viewport, event, shape_idx):
	if event is InputEventMouse:
		if level.can_place and event.button_mask == MOUSE_BUTTON_MASK_LEFT and delete_process:
			queue_free()
		if level.can_remove and event.button_mask == MOUSE_BUTTON_MASK_LEFT and deleteable:
			sprite.modulate = Color(255,255,255,0.5)
			delete_process = true


func _on_leftjoint_area_entered(area):
	left = true
	refresh()


func _on_leftjoint_area_exited(area):
	left = false
	refresh()


func _on_rightjoint_area_entered(area):
	right = true
	refresh()


func _on_rightjoint_area_exited(area):
	right = false
	refresh()


func _on_topjoint_area_entered(area):
	top = true
	refresh()


func _on_topjoint_area_exited(area):
	top = false
	refresh()


func _on_bottomjoint_area_entered(area):
	bottom = true
	refresh()


func _on_bottomjoint_area_exited(area):
	bottom = false
	refresh()
