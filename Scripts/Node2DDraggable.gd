extends CollisionObject2D

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

func start_drag():
	status = DRAG_STATUSES.grabbed
	anchor_offset = global_position - get_viewport().get_mouse_position()
	grab_callback()

func grab_callback():
	pass

func drop_callback():
	pass

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed and status != DRAG_STATUSES.grabbed and can_be_dragged == true:
		start_drag()
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and not event.pressed and status == DRAG_STATUSES.grabbed:
		status = DRAG_STATUSES.released
		drop_callback()
