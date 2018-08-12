extends Node

export var FLOTSAM_SPAWN_Y = 400
export var FLOTSAM_DESTROY_X = 300
export (Texture) var grabbed_texture
export (Texture) var squashed_texture

var flotsam = load("res://Scenes/Flotsam.tscn")

var flotsam_animation_names = {
	"shark": {
		"floating": "big_float",
		"dragged": "shark_dragged",
		"stored": "shark_stored"
	}
}

func _ready():
	#spawn_flotsam(Vector2(get_viewport().get_visible_rect().size.x, 300), 3, 10, img, img)
	set_process_input(false)

func _input(ev): # made for debug purposes
	if ev is InputEventMouseButton and ev.button_index == BUTTON_LEFT and ev.pressed:
		var clicked_on_child = false
		var local_mouse_coords = get_global_transform().xform_inv(ev.position)
		for child in get_children():
			var child_texture = child.get_node("Sprite").texture
			var child_rect = Rect2(child.position.x, child.position.y, child_texture.get_size().x, child_texture.get_size().y)
			if child_rect.has_point(local_mouse_coords):
				clicked_on_child = true
		if clicked_on_child == false:
			spawn_flotsam(get_viewport().get_mouse_position(), 3, 10, grabbed_texture, squashed_texture, true)

func spawn_flotsam(position, weight, score, kind, dragged = false):
	var new_flotsam = flotsam.instance()
	var flotsam_animations = flotsam_animation_names[kind]
	new_flotsam.init(weight, score, flotsam_animations["floating"], flotsam_animations["dragged"], flotsam_animations["stored"])
	add_child(new_flotsam)
	new_flotsam.global_position = position
	# spawn an already dragged Flotsam to mouse position when left button is down or idk what will happen
	if dragged:
		new_flotsam.start_drag()

func spawn_flotsam_dict(dict):
	spawn_flotsam(get_viewport().get_mouse_position(), dict["weight"], dict["score"], dict["drag_texture"], dict["squashed_texture"], true)

func _on_Timer_timeout():
	spawn_flotsam(Vector2(get_viewport().get_visible_rect().size.x, FLOTSAM_SPAWN_Y), 3, 10, "shark")
