extends CanvasLayer

signal start_game


func _on_StartButton_pressed() -> void:
	$StartButton.hide()
	emit_signal("start_game")


func _on_MessageTimer_timeout() -> void:
	$Message.hide()


func show_message(text: String) -> void:
	$Message.text = text
	$Message.show()
	$MessageTimer.start()


func show_game_over() -> void:
	show_message("Game Over")
	yield($MessageTimer, "timeout")

	$Message.text = "Dodge the Creeps!"
	$Message.show()

	yield(get_tree().create_timer(1), "timeout")
	$StartButton.show()


func update_score(score: int) -> void:
	$ScoreLabel.text = score as String


func update_highscore(score: int) -> void:
	$HighscoreLabel.text = score as String
