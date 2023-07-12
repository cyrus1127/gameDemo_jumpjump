extends "res://scenes/scripts/level_logic.gd"


var isShopMenuReadyToShow = false

# Called when the node enters the scene tree for the first time.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	updateCamPos(delta)
	
	var select = Input.is_action_pressed("ui_select")
	var attack = Input.is_action_pressed("ui_attack")
	
	if isShopMenuReadyToShow and (select || attack ):
		$HUD_level/HUD_node_shopView.show()
		$Player_RigidBody2D.stop()
		
	pass


func _on_GoalArea2D_player_in():
#	go next level
	$Player_RigidBody2D.stop()
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

