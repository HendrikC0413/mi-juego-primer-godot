extends CanvasLayer
signal start_game

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$StartButton.show()
	$Message.text = "Dodge the Creeps!"
	$Message.show()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func show_message(text):
	$Message.text = text
	$Message.show()
	
func show_game_over():
	show_message("Game Over")
	$StartButton.hide()
	$CloseButton.hide()

	$Message.text = "Game Over"
	$Message.show()

	await get_tree().create_timer(1.5).timeout

	$Message.text = "Dodge the Creeps!"
	$Message.show()

	$StartButton.show()
	$CloseButton.show()
	
func update_score(score):
	$ScoreLabel.text = str(score)
	
func _on_start_button_pressed():
	$StartButton.hide()
	$CloseButton.hide()
	start_game.emit()
	
func _on_message_timer_timeout():
	$Message.hide()

func show_start_screen():
	$Message.text = "Dodge the Creeps!"
	$Message.show()
	$StartButton.show()
	
func show_get_ready():
	$Message.text = "Get Ready"
	$Message.show()

	await get_tree().create_timer(2.0).timeout
	$Message.hide()


func _on_close_button_pressed() -> void:
	get_tree().quit()
