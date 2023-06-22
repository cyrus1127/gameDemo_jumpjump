extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var dur = 2.5
	var start_pos = $Sprite_icon.position - Vector2(0, 350)
	var end_pos = $Sprite_icon.position
	$Sprite_icon.position = start_pos

	$tweenController.stop_all()
	yield(get_tree().create_timer(1.0), "timeout")

	# ready animation
	$tweenController.interpolate_property($Sprite_icon, "position",
		start_pos, end_pos, dur,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$tweenController.interpolate_property($Sprite_icon, "modulate", Color(1,1,1,0) , Color(1,1,1,1), dur,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$tweenController.interpolate_callback(self, dur + 1, "animEnd")
	$tweenController.start()
	
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	pass

func animEnd():
	GLOBAL.back_to_title()
	pass

func _on_Tween_tween_completed(object, key):
#	get_tree().change_scene_to(inGameScene)
	pass # Replace with function body.


func _on_Tween_tween_started(object, key):
#	print("tween is started")
	pass # Replace with function body.
