extends Node

export (int, 720) var FLOTSAM_SPAWN_Y = 500
export (int, 1280) var FLOTSAM_DESTROY_X = 300

var flotsam = load("res://Scenes/Flotsam.tscn")
var dragging = null # Flotsam we are currently dragging.

var flotsam_animation_names = {
	"shark": {
		"floating": "medium_float",
		"dragged": "shark_dragged",
		"stored": "shark_stored"
	},
	"fish": {
		"floating": "small_float",
		"dragged": "fish_dragged",
		"stored": "fish_stored"
	},
	"goldfish": {
		"floating": "small_float",
		"dragged": "goldfish_dragged",
		"stored": "goldfish_stored"
	}
}

func spawn_flotsam(position, weight, score, kind):
	var new_flotsam = flotsam.instance()
	var flotsam_animations = flotsam_animation_names[kind]
	new_flotsam.init(weight, score, flotsam_animations["floating"], flotsam_animations["dragged"], flotsam_animations["stored"])
	add_child(new_flotsam)
	new_flotsam.global_position = position

func _on_Timer_timeout():
	var weight = randi()%11+1
	var score = randi()%11+1
	var types = flotsam_animation_names.keys()
	var type_index = randi()%types.size()
	spawn_flotsam(Vector2(get_viewport().get_visible_rect().size.x, FLOTSAM_SPAWN_Y), weight, score, types[type_index])
