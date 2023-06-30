extends Node


var res_single = preload("res://assets/jalan/single.png")
var res_vertical_top = preload("res://assets/jalan/vertical-top.png")
var res_vertical_mid = preload("res://assets/jalan/vertical-mid.png")
var res_vertical_bot = preload("res://assets/jalan/vertical-bot.png")
var res_horizontal_left = preload("res://assets/jalan/horizontal-left.png")
var res_horizontal_mid = preload("res://assets/jalan/horizontal-mid.png")
var res_horizontal_right = preload("res://assets/jalan/horizontal-right.png")
var res_junction_topleft = preload("res://assets/jalan/junction-topleft.png")
var res_junction_topmid = preload("res://assets/jalan/junction-topmid.png")
var res_junction_topright = preload("res://assets/jalan/junction-topright.png")
var res_junction_midleft = preload("res://assets/jalan/junction-midleft.png")
var res_junction_midmid = preload("res://assets/jalan/junction-midmid.png")
var res_junction_midright = preload("res://assets/jalan/junction-midright.png")
var res_junction_botleft = preload("res://assets/jalan/junction-botleft.png")
var res_junction_botmid = preload("res://assets/jalan/junction-botmid.png")
var res_junction_botright = preload("res://assets/jalan/junction-botright.png")

var coords = {
	"SINGLE": Vector2i(0,3),
	"VERTICAL_TOP": Vector2i(0,0),
	"VERTICAL_MID": Vector2i(0,1),
	"VERTICAL_BOT": Vector2i(0,2),
	"HORIZONTAL_LEFT": Vector2i(1,3),
	"HORIZONTAL_MID": Vector2i(2,3),
	"HORIZONTAL_RIGHT": Vector2i(3,3),
	"JUNCTION_TOPLEFT": Vector2i(1,0),
	"JUNCTION_TOPMID": Vector2i(2,0),
	"JUNCTION_TOPRIGHT": Vector2i(3,0),
	"JUNCTION_MIDLEFT": Vector2i(1,1),
	"JUNCTION_MIDMID": Vector2i(2,1),
	"JUNCTION_MIDRIGHT": Vector2i(3,1),
	"JUNCTION_BOTLEFT": Vector2i(1,2),
	"JUNCTION_BOTMID": Vector2i(2,2),
	"JUNCTION_BOTRIGHT": Vector2i(3,2)
}
