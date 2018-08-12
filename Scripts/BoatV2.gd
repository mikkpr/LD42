extends Node2D

signal rotation(degrees) # Emitted when the rotation has updated.
signal score(score)      # Emitted when the score has updated.
signal sunk              # Emitted when the boat has sunk.

export (float) var degrees_per_tilt = 1.0 # How many degrees to tilt per weight.
export (int) var degrees_to_sink = 30     # At how many degrees to sink.

const sink_speed = 100 # How fast the boat sinks (pixels/sec).

var tilt = 0.0       # Weighted sum of the Flotsam weights.
var score = 0        # Sum of Flotsam scores.
var sinking = false  # Is the Boat sinking?
var active = null    # Current active Container.

func _process(delta):
	rotation_degrees += (tilt * degrees_per_tilt - rotation_degrees) / 2 * delta
	emit_signal("rotation", rotation_degrees)

	if !sinking:
		update_waterwheel()

	if !sinking && abs(rotation_degrees) > degrees_to_sink:
		tilt = (1 if tilt > 0 else -1) * 90.0 / degrees_per_tilt
		sinking = true
		active = null
		emit_signal("sunk")

	if sinking:
		translate(Vector2(0, sink_speed * delta))
		$WheelSplashAudio.volume_db -= 5 * delta
		$EngineAudio.volume_db -= 5 * delta
		if global_transform.origin.y > get_viewport().get_visible_rect().size.y + 300:
			queue_free()

func update_waterwheel():
	if rotation_degrees > 5:
		$WheelSplash.hide()
		$WheelSplashAudio.volume_db = -100
	else:
		$WheelSplash.show()
		$WheelSplashAudio.volume_db = 0

func store(flotsam):
	if sinking || active == null || !active.store(flotsam):
		return false
	tilt += active.coefficient * flotsam.weight
	score += flotsam.score
	emit_signal("score", score)
	return true

func remove():
	if sinking || active == null:
		return null
	var flotsam = active.remove()
	if flotsam == null:
		return null
	tilt -= active.coefficient * flotsam.weight
	score -= flotsam.score
	emit_signal("score", score)
	return flotsam

func _activate(container):
	if !sinking:
		active = container

func _deactivate(container):
	# Only deactivate if container is active, because otherwise things
	# break if we get out-of-order signals (activate A, activate B,
	# deactivate A).
	if active == container:
		active = null
