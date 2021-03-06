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
	if (event is InputEventMouseButton and event.button_index == BUTTON_LEFT and
			event.pressed and status == DRAG_STATUSES.released and can_be_dragged):
		if grab_callback():
			status = DRAG_STATUSES.grabbed

func _unhandled_input(event): # Even if not released over this CollisionObject2D.
	if (event is InputEventMouseButton and event.button_index == BUTTON_LEFT and
			not event.pressed and status == DRAG_STATUSES.grabbed):
		if drop_callback():
			status = DRAG_STATUSES.released
