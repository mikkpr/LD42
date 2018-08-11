extends Node2D

func _ready():
	calculate()

func calculate():
	var total = 0
	for i in range($Boxes.get_child_count()):
		var indices = [-2, -1, 1, 2]
		var box_index = indices[((i + 1) % 4) - 1]
		var box_value = $Boxes.get_children()[i].value
		total += box_index * box_value

#		print("%s at %s (%s)" % [box_value, box_index, i])
	$Label.text = "total: %s" % String(total)
	update_tilt(total)


func update_tilt(deg):
	print(deg)
	$Tilt.rotation = deg / 360 * 2 * PI

func _on_SpinBox_value_changed(value):
	calculate()
