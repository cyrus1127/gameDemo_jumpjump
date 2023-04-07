extends Node2D
signal menu_closed
signal qite_level

# Declare member variables here. Examples:


# Called when the node enters the scene tree for the first time.
func _ready():
	updateBtnText()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func updateBtnText():
	var onoffText = "On"
	if !GLOBAL.music_isOn :
		onoffText = "off"	
	$item_info_rect/btn_filter_0/Label.text = "Music" + onoffText
	pass

func _on_btn_resume_pressed():
	hide()
	emit_signal("menu_closed")
	pass # Replace with function body.


func _on_btn_quit_pressed():
	GLOBAL.save_game()
	GLOBAL.back_to_title()
	pass # Replace with function body.


func _on_btn_close_pressed():
	hide()
	emit_signal("menu_closed")
	pass # Replace with function body.


func _on_btn_music_pressed():
	GLOBAL.musicOnOff()
	updateBtnText()
	
	pass # Replace with function body.
