extends Node

export (int, 720) var FLOTSAM_SPAWN_Y = 500
export (int, 1280) var FLOTSAM_DESTROY_X = 300
export (float) var TIMER_MIN = 0.5
export (float) var TIMER_MAX = 3.5

var flotsam = load("res://Scenes/Flotsam.tscn")
var dragging = null # Flotsam we are currently dragging.

var flotsam_kinds = {
	"shark": {
		"weight_range": Vector2(5, 7),
		"score_range": Vector2(5, 7),
		"floating": "medium_float",
		"dragged": "shark_dragged",
		"stored": "shark_stored"
	},
	"fish": {
		"weight_range": Vector2(3, 4),
		"score_range": Vector2(3, 4),
		"floating": "small_float",
		"dragged": "fish_dragged",
		"stored": "fish_stored"
	},
	"goldfish": {
		"weight_range": Vector2(1, 2),
		"score_range": Vector2(1, 2),
		"floating": "small_float",
		"dragged": "goldfish_dragged",
		"stored": "goldfish_stored"
	},
	"whale": {
		"weight_range": Vector2(8, 10),
		"score_range": Vector2(8, 10),
		"floating": "big_float",
		"dragged": "whale_dragged",
		"stored": "whale_stored"
	}
}

func spawn_flotsam(position, weight, score, kind):
	var new_flotsam = flotsam.instance()
	new_flotsam.init(weight, score, kind["floating"], kind["dragged"], kind["stored"])
	new_flotsam.global_position = position
	add_child(new_flotsam)

func _on_Timer_timeout():
	$Timer.wait_time = rand_range(TIMER_MIN, TIMER_MAX)
	var keys = flotsam_kinds.keys()
	var kind = flotsam_kinds[keys[randi() % keys.size()]]
	var right_side = get_viewport().get_visible_rect().size.x
	spawn_flotsam(Vector2(right_side, _rand_range(Vector2(FLOTSAM_SPAWN_Y - 30, FLOTSAM_SPAWN_Y + 30))),
			_rand_range(kind["weight_range"]), _rand_range(kind["score_range"]), kind)

func _rand_range(vec2):
	return vec2.x + (randi() % int(vec2.y - vec2.x + 1))
