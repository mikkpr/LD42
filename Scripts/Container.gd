extends Node

export (Texture) var background  # Texture to use as Container background.
export (bool) var store_flotsam = true  # Can this Container store flotsam?

var flotsam  # Flotsam stored in this container.

func _ready():
	$Background.texture = background

func store(flotsam):
	if store_flotsam || flotsam != null:
		return false
	self.flotsam = flotsam
	$Contents.texture = flotsam["squashed_texture"]
	$Contents.visible = true
	return true

func clear():
	flotsam = null
	$Contents.visible = false
	$Contents.texture = null
