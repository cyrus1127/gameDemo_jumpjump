extends CanvasLayer
signal start_game

# Declare member variables here. Examples:



# Called when the node enters the scene tree for the first time.
func _ready():
	$playerInfo/lbl_.text = str(GLOBAL.playerData.level)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func show_message(text):
	$lbl_msg.text = text
	$lbl_msg.show()
	$Timer_msg.start()
	pass
	
func show_game_over():
	
	$lbl_title.show()
	show_message("Game Over")
	yield($Timer_msg, "timeout")
	
	$lbl_msg.text = "Dodge the\nMosters!"
	$lbl_msg.show()
	
	yield(get_tree().create_timer(1),"timeout")
	$btn_start.show()
	
	pass


func _on_Timer_msg_timeout():
	$lbl_msg.hide()
	pass # Replace with function body.


func _on_btn_start_pressed():
	$lbl_title.hide()
	$btn_start.hide()
	emit_signal("start_game")
	pass # Replace with function body.
