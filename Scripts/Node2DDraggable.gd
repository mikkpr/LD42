extends Node2D

enum DRAG_STATUSES {
	released,
	grabbed
}

var can_be_dragged = true

var status = DRAG_STATUSES.released
var tsize = Vector2()
var anchor_offset = Vector2()

func _process(delta):
	if status == DRAG_STATUSES.grabbed:
		global_position = get_viewport().get_mouse_position() + anchor_offset

func _input(ev):
	var texture = get_node("Sprite").get_texture()
	if texture == null:
		pass
	else:
		tsize = texture.get_size()
		if ev is InputEventMouseButton and ev.button_index == BUTTON_LEFT and ev.pressed and status != DRAG_STATUSES.grabbed and can_be_dragged == true:
			var mouse_position = ev.position
			var gpos = global_transform.origin
			var spriterect
			if get_node("Sprite").centered:
				spriterect = Rect2(gpos.x-tsize.x/2, gpos.y-tsize.y/2, tsize.x, tsize.y)
			else:
				spriterect = Rect2(gpos.x, gpos.y, tsize.x, tsize.y)
			if spriterect.has_point(mouse_position):
				start_drag()
		if ev is InputEventMouseButton and ev.button_index == BUTTON_LEFT and not ev.pressed and status == DRAG_STATUSES.grabbed:
			if not ev.pressed:
				status = DRAG_STATUSES.released
				drop_callback()

func start_drag():
	status = DRAG_STATUSES.grabbed
	anchor_offset = global_position - get_viewport().get_mouse_position()
	grab_callback()

func grab_callback():
	pass

func drop_callback():
	pass
