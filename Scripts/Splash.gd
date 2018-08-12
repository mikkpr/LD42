extends Node2D

func _ready():
	$Animation.connect("animation_finished", self, "_on_splash_finished")

func play():
	$Animation.play('splash')

func _on_splash_finished():
	print("destroy splash? %s" % position)
	queue_free()