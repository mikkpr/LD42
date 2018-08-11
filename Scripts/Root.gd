extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	$UI/TotalLabel.update(400)
	$UI/TimerLabel.connect("finished", self, "on_game_over")
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func on_game_over():
	print("on_game_over")
