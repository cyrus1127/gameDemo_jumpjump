extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func showMsg(var n_msg):
	$msg_box/lbl_contents.text = n_msg
	show()
	pass

func _on_btn_msgbox_close_button_down():
	hide()
	pass # Replace with function body.
