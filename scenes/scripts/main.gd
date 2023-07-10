extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export (PackedScene) var dustEffect

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var dur = 1.5
	var start_pos = $Sprite_icon.position - Vector2(0, 350)
	var end_pos = $Sprite_icon.position
	$Sprite_icon.position = start_pos

	$tweenController.stop_all()
	yield(get_tree().create_timer(1.0), "timeout")

	# ready animation
	$tweenController.interpolate_property($Sprite_icon, "position",
		start_pos, end_pos, dur,
		Tween.TRANS_BOUNCE, Tween.EASE_OUT)
	$tweenController.interpolate_property($Sprite_icon, "modulate", Color(1,1,1,0) , Color(1,1,1,1), dur,Tween.TRANS_CUBIC, Tween.EASE_OUT)
	$tweenController.interpolate_callback(self, 0.5, "playDustes")
	$tweenController.interpolate_callback(self, dur + 2, "animEnd")
	$tweenController.start()
	
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	pass

func animEnd():
	GLOBAL.back_to_title()
	pass

func playDustes():
	if dustEffect :
		$move_fx_node_l.startAnim_set2(true)
		$move_fx_node_l2.startAnim_set2(true,true, 0.1)
		$move_fx_node_l3.startAnim_set2(true,true, 0.6)

		$move_fx_node_r.startAnim_set2(true, false)
		$move_fx_node_r2.startAnim_set2(true, false,0.1)
		$move_fx_node_r3.startAnim_set2(true, false,0.6)
	pass
