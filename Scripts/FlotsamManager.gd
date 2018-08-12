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
		"score_range": Vector2(50, 70),
		"floating": "medium_float",
		"dragged": "shark_dragged",
		"stored": "shark_stored",
		"rarity": 3
	},
	"fish": {
		"weight_range": Vector2(3, 4),
		"score_range": Vector2(30, 40),
		"floating": "small_float",
		"dragged": "fish_dragged",
		"stored": "fish_stored",
		"rarity": 1
	},
	"goldfish": {
		"weight_range": Vector2(1, 2),
		"score_range": Vector2(80, 188),
		"floating": "small_float",
		"dragged": "goldfish_dragged",
		"stored": "goldfish_stored",
		"rarity": 7
	},
	"whale": {
		"weight_range": Vector2(8, 10),
		"score_range": Vector2(80, 100),
		"floating": "big_float",
		"dragged": "whale_dragged",
		"stored": "whale_stored",
		"rarity": 4
	},
	"mermaid": {
		"weight_range": Vector2(3, 6),
		"score_range": Vector2(140, 150),
		"floating": "medium_float",
		"dragged": "mermaid_dragged",
		"stored": "mermaid_stored",
		"rarity": 8
	},
	"shoe": {
		"weight_range": Vector2(1, 1),
		"score_range": Vector2(0, 3),
		"floating": "small_float",
		"dragged": "shoe_dragged",
		"stored": "shoe_stored",
		"rarity": 7
	},
	"heavyweight": {
		"weight_range": Vector2(25, 25),
		"score_range": Vector2(10, 10),
		"floating": "big_float",
		"dragged": "heavyweight_dragged",
		"stored": "heavyweight_stored",
		"rarity": 9
	}
}

func _ready():
	randomize() # Seed RNG.

func spawn_flotsam(position, weight, score, kind):
	var new_flotsam = flotsam.instance()
	new_flotsam.init(weight, score, kind["floating"], kind["dragged"], kind["stored"])
	new_flotsam.global_position = position
	add_child(new_flotsam)

func _on_Timer_timeout():
	$Timer.wait_time = rand_range(TIMER_MIN, TIMER_MAX)
	var kind = _rand_flotsam()
	var right_side = get_viewport().get_visible_rect().size.x
	spawn_flotsam(Vector2(right_side, _rand_range(Vector2(FLOTSAM_SPAWN_Y - 30, FLOTSAM_SPAWN_Y + 30))),
			_rand_range(kind["weight_range"]), _rand_range(kind["score_range"]), kind)

func _rand_range(vec2):
	return vec2.x + (randi() % int(vec2.y - vec2.x + 1))

func _rand_flotsam():
	var keys = flotsam_kinds.keys()
	var flotsamWithRarity = flotsam_kinds[keys[randi() % keys.size()]]
	if (randi()%11+1) < flotsamWithRarity["rarity"]:
		flotsamWithRarity = _rand_flotsam()
	return flotsamWithRarity
