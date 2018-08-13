extends Node2D

onready var retryButton = $Scoreboard/Retry/UI/MarginContainer/ButtonContainer/Button

onready var left_box = $Boat/Cargo.get_child(0)
onready var right_box = $Boat/Cargo.get_child(1)

var isFinished = false

func _ready():
	retryButton.connect("pressed", self, "retry_button_pressed")
	$Scoreboard/Retry/UI/MarginContainer/Label.text = "Good job! Now on to the real thing!"
	$Scoreboard/Retry/UI/MarginContainer/ButtonContainer/Button.text = "Continue"
	$UIContainer/UI/GuidanceLabel.margin_top = 0
	$UIContainer/UI/GuidanceLabel.margin_bottom = 300
	$FlotsamManager/Timer.stop()
	$UIContainer/UI/GameTimer.paused = true
	$UIContainer/UI/TimerLabel.visible = false
	left_box.visible = false
	left_box.connect("stored", self, "_on_left_stored")
	left_box.connect("removed", self, "_on_left_removed")
	right_box.connect("stored", self, "_on_right_stored")
	right_box.connect("removed", self, "_on_right_removed")
	tutorial(1)

func tutorial(step):
	match step:
		1:
			show_tip("Drag stuff to boxes")
			spawn_flotsam("whale")
		2:
			show_tip("Look how much the whale is worth!!!")
			$Boat.connect("rotation", self, "sinking")
		3:
			#show_tip("Don't let her sink!")
			pass
		4:
			left_box.visible = true
			right_box.get_node("Contents").get_child(0).input_pickable = true
			show_tip("Dont let her sink! Move whale to the other box!")
		5:
			show_tip("Wow this is way better!")
			$Boat.connect("rotation", self, "stabilising")
		6:
			right_box.visible = true
		7:
			hide_tip()
			$Boat.call_deferred("dock")
			$Scoreboard.show(false)


func sinking(amount):
	if amount > 20:
		$Boat.disconnect("rotation", self, "sinking")
		tutorial(4)
	#elif amount > 10:
	#	tutorial(3)

func stabilising(amount):
	if amount < 10:
		$Boat.disconnect("rotation", self, "stabilising")
		tutorial(5)

func _process(delta):
	if isFinished:
		return

func show_tip(message):
	$UIContainer/UI/GuidanceLabel.text = message
	$UIContainer/UI/GuidanceLabel.show()

func hide_tip():
	$UIContainer/UI/GuidanceLabel.hide()

func retry_button_pressed():
	get_tree().change_scene("res://Scenes/TestLevel.tscn")

func menu_button_pressed():
	get_tree().change_scene("res://Scenes/MainMenu.tscn")

func spawn_flotsam(f_kind):
	var kind = $FlotsamManager.flotsam_kinds[f_kind]
	var right_side = get_viewport().get_visible_rect().size.x
	var flotsam = $FlotsamManager.spawn_flotsam(Vector2(right_side, $FlotsamManager._rand_range(Vector2($FlotsamManager.FLOTSAM_SPAWN_Y - 30, $FlotsamManager.FLOTSAM_SPAWN_Y + 30))),
			$FlotsamManager._rand_range(kind["weight_range"]), $FlotsamManager._rand_range(kind["score_range"]), kind)
	flotsam.connect("flotsam_destroyed", self, "_on_flotsam_destroyed", [f_kind])

func _on_flotsam_destroyed(kind):
	spawn_flotsam(kind)
	show_tip("Don't drop stuff!")

func _on_left_stored(flotsam):
	# Whatever is put in the left container stays there forever.
	$Boat.disconnect("rotation", self, "sinking")
	left_box.get_node("Contents").get_child(0).input_pickable = false
	show_tip("Shark weighs less but is farther away so it tilts you more!")
	spawn_flotsam("shark")
	tutorial(6)

func _on_left_removed(flotsam):
	pass

func _on_right_stored(flotsam):
	right_box.get_node("Contents").get_child(0).input_pickable = false
	if flotsam.stored_animation_name == "whale_stored":
		tutorial(2)
	else:
		tutorial(7)

func _on_right_removed(flotsam):
	# You can only remove once from the right container.
	right_box.visible = false
