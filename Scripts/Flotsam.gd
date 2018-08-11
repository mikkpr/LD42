extends "./Node2DDraggable.gd"

export(int) var weight
export(int) var score
export(Texture) var drag_texture
export(Texture) var squashed_texture

var weight_size_coefficient = 10
var fall_speed = 500
var float_speed = 200

enum STATES {
	floating,
	dragging,
	dropped
}

var flotsam_state = STATES.floating

func init(i_weight, i_score, i_drag_texture, i_squashed_texture):
	weight = i_weight
	score = i_score
	drag_texture = i_drag_texture
	squashed_texture = i_squashed_texture
	paint_initial_texture()
	get_node("Label").text = String(score)

func paint_initial_texture():
	var float_texture = ImageTexture.new()
	var texture_image = Image.new()
	texture_image.create(weight*weight_size_coefficient, weight*weight_size_coefficient, false, Image.FORMAT_RGBAF)
	texture_image.fill(Color(1, 0, 0, 0.5))
	float_texture.create_from_image(texture_image)
	get_node("Sprite").texture = float_texture

func _process(delta):
	if flotsam_state == STATES.floating:
		if position.x < get_parent().flotsam_destroy_line:
			flotsam_state = STATES.dropped
			can_be_dragged = false
		else:
			var float_vector = Vector2()
			float_vector.x = - float_speed * delta
			float_vector.y = 0
			translate(float_vector)
	if flotsam_state == STATES.dropped:
		if global_transform.origin.y - get_node("Sprite").texture.get_size().y/2 > get_viewport().get_visible_rect().size.y:
			print("Flotsam destroyed")
			queue_free()
		else:
			var fall_vector = Vector2()
			fall_vector.x = 0
			fall_vector.y = fall_speed * delta
			translate(fall_vector)

func grab_callback():
	get_node("Sprite").texture = drag_texture
	flotsam_state = STATES.dragging
	get_node("Label").visible = true
	print("Flotsam grabbed")

func drop_callback():
	if false: # PLACEHOLDER, replace to asking "so should I be dropped or what?"
		pass
	else:
		flotsam_state = STATES.dropped
		can_be_dragged = false
	get_node("Label").visible = false
	print("Flotsam dropped")

