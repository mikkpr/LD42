extends GridContainer

var tilt = 0.0  # Weighted sum of the flotsam weights.
var coeffs = {  # Coefficients for tilt calculation.
	0: -1.2, 1: 1.2,
	2: -1.1, 3: 1.1,
	4: -1.0, 5: 1.0,
}

func store(flotsam, coords):
	var container = _container_at(coords)
	if container == null || !container.store(flotsam):
		return false
	_update_tilt(true, container.get_position_in_parent(), flotsam.weight)
	return true

func pickup(coords):
	var container = _container_at(coords)
	if container == null:
		return null
	var flotsam = container.flotsam
	container.clear()
	if flotsam != null:
		_update_tilt(false, container.get_position_in_parent(), flotsam.weight)
	return flotsam

func _container_at(coords):
	var local = get_global_transform().xform_inv(coords)
	for container in get_children():
		if container.get_rect().has_point(local):
			return container
	return null

func _update_tilt(add, index, weight):
	print("Adding weight %d to index %d" % [weight, index])
	tilt += (1 if add else -1) * weight * coeffs[index]
	print("New tilt %f" % tilt)
