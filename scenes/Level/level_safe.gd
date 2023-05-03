extends Node2D


# Declare member variables here. Examples:
var screen_size
var isShopMenuReadyToShow = false

## =-=-=-=-=- player informations
var player_hp = 100
var player_sp = 100
var player_coins = 0
var player_exp = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	check_play_pos()
	
	#Player data ready
	player_coins =  GLOBAL.playerData.balance
	player_exp = GLOBAL.playerData.level_exp
	player_hp = GLOBAL.playerData.hp
	player_sp = GLOBAL.playerData.sp
	
	#Scene ready
	$Player_RigidBody2D.start($pos_start.position)
	$HUD_level.update_hp(player_hp)
	$HUD_level.update_coin(GLOBAL.playerData.balance)
	
	if $Player_RigidBody2D.isTouchScreenOn:
		$HUD_level/Control
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	var select = Input.is_action_pressed("ui_select")
	
	if isShopMenuReadyToShow and select:
		$HUD_level/HUD_node_shopView.show()
		$Player_RigidBody2D.stop()
		
	pass

func check_play_pos():
	screen_size = get_viewport_rect().size
	$Player_RigidBody2D/Camera2D .position = Vector2(-100,-350)
	pass # Replace with function body.

func _on_GoalArea2D_player_in():
#	go next level
	get_tree().change_scene("res://scens/game.tscn")
	pass # Replace with function body.


func _on_DeadArea2D_player_in():
	$Player_RigidBody2D.start($pos_start.position)
	pass # Replace with function body.


func _on_ItemShop_player_in_Shop():
	isShopMenuReadyToShow = true
	pass # Replace with function body.


func _on_ItemShop_player_leave_Shop():
	isShopMenuReadyToShow = false
	pass # Replace with function body.


func _on_HUD_level_meun_closed():
	$Player_RigidBody2D.resume()
	pass # Replace with function body.
