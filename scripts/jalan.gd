extends Node2D


@onready var sprite = $Sprite2D
@onready var clickable = $clickable
var left = null
var right = null
var up = null
var down = null
var deleteable = true
var delete_process = false

func _ready():
	sprite.set_texture(BaseJalan.res_junction_midmid)


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
		queue_free()


# deteksi klik kanan mouse untuk menghapus jalan
func _on_clickable_input_event(viewport, event, shape_idx):
	if event is InputEventMouse:
		if event.button_mask == MOUSE_BUTTON_MASK_LEFT and delete_process:
			queue_free()
		if event.button_mask == MOUSE_BUTTON_MASK_RIGHT and deleteable:
			sprite.modulate = Color(255,255,255,0.5)
			delete_process = true
