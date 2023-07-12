extends CanvasLayer

signal btn_pressed_backtotitle
signal btn_pressed_nextlevel
signal timeToReset
signal btn_pressed_retry
signal meun_closed
signal meun_onshow
signal item_selected
signal character_info_onshow
signal character_info_closed
signal player_recovered(hp_val,sp_val)


# Declare member variables here. Examples:
var timer_reborn_counting

export var touchEnable = false

# Called when the node enters the scene tree for the first time.
func _ready():
	update_coin(GLOBAL.playerData.balance)
	$panel_result.hide()
	
	pass # Replace with function body.

func setTouchOn(var isNeed : bool = false):
	touchEnable = isNeed
	if touchEnable :
		$Control.show()
	else :
		$Control.hide()
	pass

func initBaseHPSP(n_hp, n_sp):
	$CharacterInfo_short/bar_hp.max_value = n_hp
	$CharacterInfo_short/bar_sp.max_value = n_sp
	update_hp(n_hp)
	update_sp(n_sp)
	$HUD_node_characterInfo.initBaseHPSP(n_hp, n_sp)

func update_hp(n_val):
	$CharacterInfo_short/bar_hp.value = n_val
	$HUD_node_characterInfo.update_hp(n_val)
	pass

func update_sp(n_val):
	$CharacterInfo_short/bar_sp.value = n_val
	$HUD_node_characterInfo.update_sp(n_val)
	pass
	
func update_coin(n_val):
	$CharacterInfo_short/bar_coinBalance/lbl_bal.text = str(n_val);

func showResult(score:int, jumps:int , falls:int , btnName:String = ""):
	$panel_result/rect_result/lbl_score/value.text = str(score)
	$panel_result/rect_result/lbl_jumps/value.text = str(jumps)
	$panel_result/rect_result/lbl_falls/value.text = str(falls)
	
	$panel_result/rect_result/btn_nextlevel.text = "Next level"
	if btnName.length() > 0 :
		$panel_result/rect_result/btn_nextlevel.text = btnName
	
	$panel_result.show()
	pass

func showDeadView(isReborn):
	$panel_result_dead.show()
	
	if isReborn :
		timer_reborn_counting = 1
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

func showBossHPBar(bossName:String, bossHP:int):
	if !$HUD_bossHPbar.is_visible() :
		$HUD_bossHPbar.setVal(bossName, bossHP)
		$HUD_bossHPbar.showWithTween()
	pass

func updateBossHP(bossHP:int):
	$HUD_bossHPbar.updateCurHP(bossHP)
	pass
	
func hiddenBossHPBar():
	$HUD_bossHPbar.hide()
	pass
	

# =-=-=-=-=-=-=- delegate

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


func _on_HUD_node_pauseMenu_menu_closed():
	emit_signal("meun_closed")
	pass # Replace with function body.


func _on_HUD_node_shopView_item_selected(index):
	emit_signal("item_selected",index)
	pass # Replace with function body.


func _on_btn_characterInfo_trigger_pressed():
#	emit_signal("character_info_onshow")
	emit_signal("meun_onshow")
	$HUD_node_characterInfo.show()
	$HUD_node_characterInfo.update()
	$Control.hide()
	$CharacterInfo_short.hide()
	$btn_pause.hide()
	pass # Replace with function body.


func _on_HUD_node_characterInfo_closed():
#	emit_signal("character_info_closed")
	emit_signal("meun_closed")
	if touchEnable :
		$Control.show()
	$CharacterInfo_short.show()
	$btn_pause.show()
	pass # Replace with function body.


func _on_HUD_node_shopView_userInfo_changed():
	update_coin(GLOBAL.playerData.balance)
	pass # Replace with function body.


func _on_jump_button_down():
	pass # Replace with function body.


func _on_attack_button_down():
	pass # Replace with function body.


func _on_btn_pause_pressed():
	$HUD_node_pauseMenu.show()
	emit_signal("meun_onshow")
	pass # Replace with function body.

func _on_HUD_node_characterInfo_player_recovered(hp, sp):
	emit_signal("player_recovered",hp, sp)
	pass # Replace with function body.
