extends CanvasLayer

signal btn_pressed_backtotitle
signal btn_pressed_nextlevel
signal timeToReset
signal btn_pressed_retry
signal meun_closed
signal meun_onshow

# Declare member variables here. Examples:
var init_hp = 100
var init_sp = 100
var timer_reborn_counting


# Called when the node enters the scene tree for the first time.
func _ready():
	update_hp(init_hp)
	update_sp(init_sp)
	update_coin(GLOBAL)
	$panel_result.hide()
	pass # Replace with function body.

func update_hp(n_val):
	$CharacterInfo_short/bar_hp.value = n_val;
	pass

func update_sp(n_val):
	$CharacterInfo_short/bar_sp.value = n_val;
	pass
	
func update_coin(n_val):
	$CharacterInfo_short/bar_coinBalance/lbl_bal.text = str(n_val);

func showResult(score:int, jumps:int , falls:int):
	$panel_result/rect_result/lbl_score/value.text = str(score)
	$panel_result/rect_result/lbl_jumps/value.text = str(jumps)
	$panel_result/rect_result/lbl_falls/value.text = str(falls)
	$panel_result.show()
	pass

func showDeadView(isReborn):
	$panel_result_dead.show()
	
	if isReborn :
		timer_reborn_counting = 5
		$panel_result_dead/lbl_subtitle.text = "reborn in "+ str(timer_reborn_counting) +"s"
		$panel_result_dead/lbl_subtitle.show()
		$panel_result_dead/btn_retry.hide()
		$panel_result_dead/btn_backtotitle_dead.hide()
		$timer_reborn.start()
	else : 
		$panel_result_dead/lbl_subtitle.hide()
		$panel_result_dead/btn_retry.show()
		$panel_result_dead/btn_backtotitle_dead.show()
		
	pass


func _on_timer_reborn_timeout():
	timer_reborn_counting -= 1
	if timer_reborn_counting >= 0:
		$panel_result_dead/lbl_subtitle.text = "reborn in "+ str(timer_reborn_counting) +"s"
	else:
		$timer_reborn.stop()
		$panel_result_dead.hide()
		emit_signal("timeToReset")
	pass # Replace with function body.


#The button of player dead
func _on_btn_backtotitle_dead_button_down():
	emit_signal("btn_pressed_backtotitle")
	pass # Replace with function body.


func _on_btn_retry_button_down():
	emit_signal("btn_pressed_retry")
	pass # Replace with function body.


func _on_btn_backtotitle_button_down():
	emit_signal("btn_pressed_backtotitle")
	pass # Replace with function body.


func _on_btn_nextlevel_button_down():
	emit_signal("btn_pressed_nextlevel")
	pass # Replace with function body.


func _on_HUD_node_shopView_shop_closed():
	emit_signal("meun_closed")
	pass # Replace with function body.


func _on_TextureButton_pressed():
	$HUD_node_pauseMenu.show()
	emit_signal("meun_onshow")
	pass # Replace with function body.


func _on_HUD_node_pauseMenu_menu_closed():
	emit_signal("meun_closed")
	pass # Replace with function body.
