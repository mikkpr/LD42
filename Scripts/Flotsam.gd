extends "./Node2DDraggable.gd"

export(int) var weight
export(int) var score
export(String) var float_animation_name
export(String) var drag_animation_name
export(String) var stored_animation_name

var fall_speed = 500
var float_speed = 100

enum STATES {
	floating,
	dragging,
	dropped,
	stored
}

var flotsam_state = STATES.floating

var parent = null
var boat = null
var Splash = preload("res://Scenes/Splash.tscn")

func init(i_weight, i_score, i_float_animation, i_drag_animation, i_stored_animation):
	weight = i_weight
	score = i_score
	float_animation_name = i_float_animation
	drag_animation_name = i_drag_animation
	stored_animation_name = i_stored_animation
	paint_initial_texture()
	$Label.text = String(score)

func _ready():
	connect("input_event", self, "_input_event")
	_change_state(STATES.floating)
	parent = get_parent()
	boat = get_tree().get_root().find_node("Boat", true, false)
	connect("area_entered", self, "_on_area_entered")

func paint_initial_texture():
	$AnimatedSprite.animation = float_animation_name

func _change_state(new_state):
	print("old state: %s, new state: %s" % [flotsam_state, new_state])
	match new_state:
		floating:
			$AnimationPlayer.play('Float')
			$Label.visible = false
		dragging:
			$AnimationPlayer.stop(true)
			$AnimationPlayer.seek(0, true)
			$Label.visible = true
		dropped:
			$AnimationPlayer.play('Sink')
			$Label.visible = false
		stored:
			$Label.visible = false

	flotsam_state = new_state

func _process(delta):
	if flotsam_state == STATES.floating:
		if position.x < parent.FLOTSAM_DESTROY_X:
			_change_state(STATES.dropped)
			can_be_dragged = false
		else:
			var float_vector = Vector2(- float_speed * delta, 0)
			translate(float_vector)
	if flotsam_state == STATES.dropped:
		if global_transform.origin.y > get_viewport().get_visible_rect().size.y:
			print("Flotsam destroyed")
			queue_free()
		else:
			var fall_vector = Vector2()
			fall_vector.x = 0
			fall_vector.y = fall_speed * delta
			translate(fall_vector)

func grab_callback():
	if parent.dragging != null:
		return false
	parent.dragging = self
	$AnimatedSprite.animation = drag_animation_name
	if flotsam_state == STATES.stored:
		boat.remove()
		parent.add_child(self)
	_change_state(STATES.dragging)
	print("Flotsam grabbed")
	return true

func drop_callback():
	print(get_viewport().get_mouse_position())
	parent.remove_child(self)
	if boat.store(self):
		$AnimatedSprite.animation = stored_animation_name
		_change_state(STATES.stored)
	else:
		parent.add_child(self)
		_change_state(STATES.dropped)
		can_be_dragged = false
	$Label.visible = false
	print("Flotsam dropped")

	if parent.dragging == self:
		parent.dragging = null
	return true


func _on_area_entered(area):
	if area.is_in_group("waterline") and flotsam_state == STATES.dropped:
		var x = int(position.x)
		var y = int(position.y + 24)
		var splash_position = Vector2(x, y)
		var splash = Splash.instance()
		splash.global_position = splash_position
		get_tree().get_root().add_child(splash)
		get_tree().get_root().move_child(splash, 0)
		splash.play()
		print("splash: %s" % splash.global_position)

