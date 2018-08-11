extends Node

var flotsam = load("res://Scenes/Flotsam.tscn")
var img = load("res://icon.png")

func _ready():
	spawn_flotsam(Vector2(300, 300))

func _input(ev):
	if ev is InputEventMouseButton and ev.button_index == BUTTON_LEFT and ev.pressed:
		var clicked_on_child = false
		var local_mouse_coords = get_global_transform().xform_inv(ev.position)
		for child in get_children():
			var child_texture = child.get_node("Sprite").texture
			var child_rect = Rect2(child.position.x, child.position.y, child_texture.get_size().x, child_texture.get_size().y)
			if child_rect.has_point(local_mouse_coords):
				clicked_on_child = true
		if clicked_on_child == false:
			spawn_flotsam(get_viewport().get_mouse_position(), true)

func spawn_flotsam(position, dragged = false):
	var new_flotsam = flotsam.instance()
	new_flotsam.init(3, 10, img, img)
	add_child(new_flotsam)
	new_flotsam.global_position = position
	if dragged:
		new_flotsam.start_drag()
