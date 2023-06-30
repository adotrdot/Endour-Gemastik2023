extends Node2D


@onready var sprite = $Sprite2D
var left = null
var right = null
var up = null
var down = null
var deleteable = true

func _ready():
	sprite.set_texture(BaseJalan.res_junction_midmid)


func _process(delta):
	pass


# deteksi klik kanan mouse untuk menghapus jalan
func _on_clickable_input_event(viewport, event, shape_idx):
	if event is InputEventMouse:
		if event.button_mask == MOUSE_BUTTON_MASK_RIGHT and deleteable:
			queue_free()
