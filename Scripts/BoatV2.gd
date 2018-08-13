extends Node2D

signal rotation(degrees) # Emitted when the rotation has updated.
signal score(score)      # Emitted when the score has updated.
signal sunk              # Emitted when the boat has sunk.
signal docked            # Emitted when the boat has docked

export (float) var degrees_per_tilt = 1.0 # How many degrees to tilt per weight.
export (int) var degrees_to_sink = 30     # At how many degrees to sink.
export (bool) var unsinkable = false      # If true, then the Boat is unsinkable.

const leave_speed = 100 # How fast the boat leaves (pixels/sec).

var tilt = 0.0       # Weighted sum of the Flotsam weights.
var score = 0        # Sum of Flotsam scores.
var active = null    # Current active Container.

enum states {
	SAILING,
	SINKING,
	DOCKING
}
var state = SAILING

func _process(delta):
	rotation_degrees += (tilt * degrees_per_tilt - rotation_degrees) / 2 * delta
	if unsinkable && abs(rotation_degrees) > degrees_to_sink:
		rotation_degrees = (1 if tilt > 0 else -1) * degrees_to_sink
	emit_signal("rotation", rotation_degrees)

	if state == SAILING:
		_update_waterwheel()

	if state == SAILING && abs(rotation_degrees) > degrees_to_sink:
		tilt = (1 if tilt > 0 else -1) * 90.0 / degrees_per_tilt
		state = SINKING
		active = null
		emit_signal("sunk")

	if state != SAILING:
		$WheelSplashAudio.volume_db -= 5 * delta
		$EngineAudio.volume_db -= 5 * delta
		if state == SINKING:
			translate(Vector2(0, leave_speed * delta))
		if state == DOCKING:
			translate(Vector2(leave_speed * delta, 0))
		var view_size = get_viewport().get_visible_rect().size
		if (global_transform.origin.x > view_size.x + 500 or
				global_transform.origin.y > view_size.y + 300):
			queue_free()
			if state == DOCKING:
				emit_signal("docked")

func _update_waterwheel():
	if rotation_degrees > 5:
		$WheelSplash.hide()
		$WheelSplashAudio.volume_db = -100
	else:
		$WheelSplash.show()
		$WheelSplashAudio.volume_db = 0

func dock():
	state = DOCKING
	active = null

func store(flotsam):
	if state != SAILING || active == null || !active.store(flotsam):
		return false
	tilt += active.coefficient * flotsam.weight
	score += flotsam.score
	emit_signal("score", score)
	return true

func remove():
	if state != SAILING || active == null:
		return null
	var flotsam = active.remove()
	if flotsam == null:
		return null
	tilt -= active.coefficient * flotsam.weight
	score -= flotsam.score
	emit_signal("score", score)
	return flotsam

func _activate(container):
	if state == SAILING:
		active = container

func _deactivate(container):
	# Only deactivate if container is active, because otherwise things
	# break if we get out-of-order signals (activate A, activate B,
	# deactivate A).
	if active == container:
		active = null
