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
	spawn_flotsam("whale")

	left_box.visible = false
	left_box.connect("stored", self, "_on_left_stored")
	left_box.connect("removed", self, "_on_left_removed")
	right_box.connect("stored", self, "_on_right_stored")
	right_box.connect("removed", self, "_on_right_removed")

func _process(delta):
	if isFinished:
		return

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

func _on_left_stored(flotsam):
	pass

func _on_left_removed(flotsam):
	pass

func _on_right_stored(flotsam):
	pass

func _on_right_removed(flotsam):
	pass
