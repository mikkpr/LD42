extends Node

export (Texture) var background  # Texture to use as Container background.

var flotsam  # Flotsam stored in this container.

func _ready():
	$Background.texture = background

func store(flotsam):
	self.flotsam = flotsam
	$Contents.texture = flotsam.squashed_texture
	$Contents.visible = true

func clear():
	flotsam = null
	$Contents.visible = false
	$Contents.texture = null
