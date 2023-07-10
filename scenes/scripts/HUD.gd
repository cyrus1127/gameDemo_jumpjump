extends CanvasLayer
signal start_game
signal go_shop

# Declare member variables here. Examples:

export (PackedScene) var noticeblock

var notices = [
	{"version":"1.1", "content":"- opening view animation fixed\n\n- title view fixed\n- Character animation fixed\n- Character moving fix and updated (add dust fx)\n- Character info updated\n- Character can wear and unequip equipment (not yet apply equipment properties )\n- leveling bug fixed\n- new level 6 \n- item drop from monster\n- exp generate from monster killed\n- add exp generate fx"},
	{"version":"1.0", "content":"nothing\nnothing\nnothing\nnothing\nnothing"},
			]

# Called when the node enters the scene tree for the first time.
func _ready():
	$playerInfo/lbl_level.text = "Level : " + str(GLOBAL.playerData.level)
	$playerInfo/lbl_Coins.text = "Coins : " + str(GLOBAL.playerData.balance)
	
	#list out all notice in board
	if noticeblock:
		var previous_block_size = 0.0
		if $NoticeBoard/ScrollContainer/VBoxContainer.get_child_count() != notices.size() :
			for notice in notices:
				var nNB = noticeblock.instance()
				nNB.setHeader(notice.version)
				nNB.setContent(notice.content)
				$NoticeBoard/ScrollContainer/VBoxContainer.add_child(nNB)
				nNB.position += Vector2(0, previous_block_size)
				previous_block_size += nNB.getSize() + 25
		$NoticeBoard/ScrollContainer/VBoxContainer.rect_min_size = Vector2(0,previous_block_size)
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	#Update the V
	
	pass


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
# =-=-=-=-=-=-=-=-=- delegate 

func _on_Timer_msg_timeout():
	$lbl_msg.hide()
	pass # Replace with function body.


func _on_btn_start_pressed():
	$lbl_title.hide()
	$btn_start.hide()
	emit_signal("start_game")
	pass # Replace with function body.


func _on_btn_shop_pressed():
	emit_signal("go_shop")
	pass # Replace with function body.


var noticeOnShow = false
func _on_btn_NB_close_pressed():
	if noticeOnShow :
		noticeOnShow = false
		$Tween.interpolate_property($NoticeBoard,"rect_scale",Vector2(1,1),Vector2(0,1), 1.5,Tween.TRANS_ELASTIC,Tween.EASE_OUT)
		$Tween.start()
	pass # Replace with function body.


func _on_btn_NB_open_pressed():
	if !noticeOnShow :
		noticeOnShow = true
		$Tween.interpolate_property($NoticeBoard,"rect_scale",Vector2(0,1),Vector2(1,1), 1.5,Tween.TRANS_ELASTIC,Tween.EASE_OUT)
		$Tween.start()
	pass # Replace with function body.
