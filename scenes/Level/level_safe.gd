extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var isShopMenuReadyToShow = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	check_play_pos()
	var select = Input.is_action_pressed("ui_select")
	
	if isShopMenuReadyToShow and select:
		$HUD_level/HUD_node_shopView.show()
		$Player_RigidBody2D.stop()
		
	pass

func check_play_pos():
	$Camera2D.position = $Player_RigidBody2D.position + Vector2(-100,-350)
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
