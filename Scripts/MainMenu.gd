extends Node

onready var GameScene


func _on_TutorialButton_pressed():
    get_tree().change_scene("res://Scenes/TutorialLevel.tscn")


func _on_NewGameButton_pressed():
    get_tree().change_scene("res://Scenes/TestLevel.tscn")


func _on_QuitButton_pressed():
    get_tree().quit()


func _on_HighScoresButton_pressed():
    get_tree().change_scene("res://Scenes/HighScores.tscn")
