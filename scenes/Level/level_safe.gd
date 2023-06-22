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
	screen_size = get_viewport_rect().size
	
	#Player data ready
	player_coins =  GLOBAL.playerData.balance
	player_exp = GLOBAL.playerData.level_exp
	player_hp = GLOBAL.playerData.hp
	player_sp = GLOBAL.playerData.sp
	
	#Scene ready
	$Player_RigidBody2D.start($pos_start.position)
	$HUD_level.update_hp(player_hp)
	$HUD_level.update_coin(GLOBAL.playerData.balance)
	$HUD_level.setTouchOn($Player_RigidBody2D.isTouchScreenOn)
	
	if $Player_RigidBody2D.isTouchScreenOn:
		$HUD_level/Control
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	updateCamPos(delta)
	
	var select = Input.is_action_pressed("ui_select")
	var attack = Input.is_action_pressed("ui_attack")
	
	if isShopMenuReadyToShow and (select || attack ):
		$HUD_level/HUD_node_shopView.show()
		$Player_RigidBody2D.stop()
		
	pass

func updateCamPos(delta):
	$Camera2D.position = $Player_RigidBody2D.position + Vector2(0,-150)
	pass


func _on_GoalArea2D_player_in():
#	go next level
	GLOBAL.next_scene()
	pass # Replace with function body.


func _on_DeadArea2D_player_in():
	$Player_RigidBody2D.start($pos_start.position)
	pass # Replace with function body.

func _on_EscArea2D_player_in():
	GLOBAL.back_to_title(true)
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

func _on_HUD_level_meun_onshow():
	$Player_RigidBody2D.stop()
	pass # Replace with function body.


func _on_HUD_level_character_info_onshow():
	$Player_RigidBody2D.stop()
	pass # Replace with function body.


func _on_HUD_level_character_info_closed():
	$Player_RigidBody2D.resume()
	pass # Replace with function body.
