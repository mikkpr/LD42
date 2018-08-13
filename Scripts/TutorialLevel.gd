extends Node2D

onready var retryButton = $Scoreboard/Retry/UI/MarginContainer/ButtonContainer/Button
onready var menuButton = $Scoreboard/UI/MarginContainer/EditContainer/MenuButton

onready var left_box = $Boat/Cargo.get_child(0)
onready var right_box = $Boat/Cargo.get_child(1)

var isFinished = false

func _ready():
	retryButton.connect("pressed", self, "retry_button_pressed")
	menuButton.connect("pressed", self, "menu_button_pressed")
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
			show_tip("Don't let her sink!")
		4:
			left_box.visible = true
			show_tip("Move whale to the other box!")
			$Boat.connect("rotation", self, "stabilising")
		5:
			show_tip("Wow this is way better!")
		6:
			right_box.visible = true
			show_tip("Shark weighs less but is farther away so it tilts you more!")
			spawn_flotsam("shark")
		7:
			show_tip("Great job!")
			$Boat.dock()

func sinking(amount):
	if amount > 20:
		$Boat.disconnect("rotation", self, "sinking")
		tutorial(4)
	elif amount > 10:
		tutorial(3)

func stabilising(amount):
	if amount < 10:
		$Boat.disconnect("rotation", self, "stabilising")
		tutorial(6)
	elif amount < 20:
		tutorial(5)

func _process(delta):
	if isFinished:
		return

func show_tip(message):
	$UIContainer/UI/GuidanceLabel.text = message
	$UIContainer/UI/GuidanceLabel.show()

func _initialize_end_screen():
	print("Tutorial DONE")
	$Boat.dock()
	isFinished = true
	
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
	left_box.get_node("Contents").get_child(0).input_pickable = false

func _on_left_removed(flotsam):
	pass

func _on_right_stored(flotsam):
	if flotsam.stored_animation_name == "whale_stored":
		tutorial(2)
	else:
		tutorial(7)

func _on_right_removed(flotsam):
	# You can only remove once from the right container.
	right_box.visible = false
