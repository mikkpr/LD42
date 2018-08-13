extends Control

func _on_Boat_score(score):
    $TotalLabel.update(score)

func _on_Boat_sunk():
    # Use paused, because stop() sets the timer to 00:00.
    $GuidanceLabel.randomTip()
    $GuidanceLabel.show()
    $GameTimer.paused = true
