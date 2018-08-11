extends Node

var tilt = 0.0    # Weighted sum of the Flotsam weights.
var active = null # Current active Container.

func store(flotsam):
	if active == null || !active.store(flotsam):
		return false
	tilt += active.coefficient * flotsam.weight
	return true

func remove():
	if active == null:
		return null
	var flotsam = active.remove()
	if flotsam == null:
		return null
	tilt -= active.coefficient * flotsam.weight
	return flotsam

func _activate(container):
	active = container

func _deactivate(container):
	active = null
