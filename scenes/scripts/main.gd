extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	

	$tweenController.stop_all()
	yield(get_tree().create_timer(1.0), "timeout")

	var start_pos = $Sprite_icon.position - Vector2(0, 200)
	var end_pos = $Sprite_icon.position
	$tweenController.interpolate_property($Sprite_icon, "position",
		start_pos, end_pos, 3,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$tweenController.interpolate_property($Sprite_icon, "position",
		start_pos, end_pos, 3,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$tweenController.start()
	yield($tweenController,"tween_completed")

#	var start_color = Color(1,1,1,1)
#	var end_color = Color(1,1,1,0)
#	$tweenController.interpolate_property($bg_color,"modulate", start_color, end_color,1)
#	$tweenController.start()
#	yield($tweenController,"tween_completed")

	yield(get_tree().create_timer(2.0),"timeout")
	
	GLOBAL.back_to_title()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	pass


func _on_Tween_tween_completed(object, key):
#	get_tree().change_scene_to(inGameScene)
	pass # Replace with function body.


func _on_Tween_tween_started(object, key):
#	print("tween is started")
	pass # Replace with function body.
