extends Node

signal entered(container) # Emitted when the mouse entered the Container.
signal exited(container)  # Emitted when the mouse exited the Container.

signal stored(child)  # Emitted when a child is stored in the Container.
signal overflowed     # Emitted when attempted to store child in full Container.
signal removed(child) # Emitted when a child is removed from the Container.
signal underflowed    # Emitted when attempted to remove from empty Container.

export (float) var coefficient = 1.0 # Weight coefficient for the Container.

func store(child):
	if $Contents.get_child_count() > 0:
		emit_signal("overflowed")
		return false
	$Contents.add_child(child)
	child.position = Vector2(0, 0)
	emit_signal("stored", child)
	return true

func remove():
	if $Contents.get_child_count() == 0:
		emit_signal("underflowed")
		return null
	var child = $Contents.get_child(0)
	$Contents.remove_child(child)
	emit_signal("removed", child)
	return child

func _on_Container_mouse_entered():
	emit_signal("entered", self)

func _on_Container_mouse_exited():
	emit_signal("exited", self)
