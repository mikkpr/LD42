extends Particles2D



func _ready():
	pass

func _on_Container_stored(child):
	print(amount)
	emitting = true
