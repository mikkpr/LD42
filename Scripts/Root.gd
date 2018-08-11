extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

const Networking = preload("Networking.gd") # Relative path

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	$UI/TotalLabel.update(400)
	$UI/TimerLabel.connect("finished", self, "on_game_over")
	
	on_game_over()
	
	pass

func on_game_over():
	print("on_game_over")
	
	var scores = Networking.new().listScores()
	print(scores[0])
	

