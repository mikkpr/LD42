extends CollisionObject2D

enum DRAG_STATUSES {
	released,
	grabbed
}

var status = DRAG_STATUSES.released
var can_be_dragged = true

func _process(delta):
	if status == DRAG_STATUSES.grabbed:
		global_position = get_viewport().get_mouse_position()

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		if event.pressed and status == DRAG_STATUSES.released and can_be_dragged:
			status = DRAG_STATUSES.grabbed
			grab_callback()
		if not event.pressed and status == DRAG_STATUSES.grabbed:
			status = DRAG_STATUSES.released
			drop_callback()
