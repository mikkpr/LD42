extends Node

var flotsam  # Flotsam stored in this container.

func store(flotsam):
	self.flotsam = flotsam
	$Contents.texture = flotsam.squashed_texture
	$Contents.visible = true

func clear():
	flotsam = null
	$Contents.visible = false
	$Contents.texture = null
