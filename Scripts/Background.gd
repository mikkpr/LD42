extends ParallaxBackground

const BASE_SPEED = -50

func _process(delta):
	scroll_offset.x += BASE_SPEED * delta
