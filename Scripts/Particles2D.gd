extends Particles2D

func _ready():
	pass

func _on_Container_stored(child):
	emitting = true
	restart()