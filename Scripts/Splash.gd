extends Node2D

func _ready():
	$Animation.connect("animation_finished", self, "_on_splash_finished")

func play():
	$Animation.play('splash')
	$Audio.play()

func _on_splash_finished():
	print("destroy splash? %s" % position)
	$Audio.stop()
	queue_free()