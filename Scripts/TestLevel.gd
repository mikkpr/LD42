extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var img = load("res://icon.png")

func _on_Timer_timeout():
	$FlotsamManager.spawn_flotsam(Vector2(get_viewport().get_visible_rect().size.x, 300), 3, 10, img, img)
