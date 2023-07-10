class_name MoveFX
extends Node2D


# Declare member variables here. Examples:
var dur = 1
var durDelay_scale = 0.25
var start_angle = -350
var end_angle = 0
var offset_start  = Vector2(0,0)
var offset_end = Vector2(0,0)
var scale_start = Vector2(0.5,0.5)
export var includePosTransaction = false

# Called when the node enters the scene tree for the first time.
func _ready():
	
	#all properties
	if includePosTransaction: #for scene load
		offset_start = $Sprite.position + Vector2(0,0)
		offset_end = $Sprite.position + Vector2(0,20)
		$Sprite.position = offset_end
	else :
		offset_start = $Sprite.position + Vector2(0,10)
		offset_end = $Sprite.position + Vector2(0,10)
		$Sprite.position = offset_end
	
	$Sprite.scale = scale_start
	
	#ready the animation
	if !includePosTransaction: #for scene load
		startAnim()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func startAnim():
	
	if $Tween && $Tween.is_inside_tree() :
		$Tween.interpolate_property($Sprite, "position", offset_end, $Sprite.position, durDelay_scale,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$Tween.interpolate_property($Sprite, "position", $Sprite.position, offset_end, dur-durDelay_scale,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, durDelay_scale)
		$Tween.interpolate_property($Sprite, "rotation", start_angle, end_angle, dur,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$Tween.interpolate_property($Sprite, "scale", scale_start, Vector2(1,1), durDelay_scale,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$Tween.interpolate_property($Sprite, "scale", Vector2(1,1), Vector2(0,0), dur-durDelay_scale,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, durDelay_scale)
		$Tween.interpolate_property($Sprite, "modulate", Color(1,1,1,1) , Color(1,1,1,0), dur,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$Tween.interpolate_callback(self, dur, "animEnd")
		$Tween.start()
		
func startAnim_set2(movement:bool = false, toLeft:bool = true , delay: float = 0.0):
	
	var offset_mid_x = offset_end
	var offset_end_x = offset_end
	var x_dist= 75
	if movement:
		if toLeft :
			offset_mid_x += Vector2(-x_dist /2 ,-5)
			offset_end_x += Vector2(-x_dist,-10)
		else:
			offset_mid_x += Vector2(x_dist /2,-5)
			offset_end_x += Vector2(x_dist,-10)
	$Sprite.set("scale",Vector2(0,0))
	show()
	if $Tween && $Tween.is_inside_tree() :
		$Tween.interpolate_property($Sprite, "position", offset_end, offset_mid_x, durDelay_scale,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT,delay)
		$Tween.interpolate_property($Sprite, "position", offset_mid_x, offset_end_x, dur-durDelay_scale,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, durDelay_scale + delay)
		$Tween.interpolate_property($Sprite, "rotation", start_angle, end_angle, dur+durDelay_scale+delay,Tween.TRANS_LINEAR, Tween.EASE_OUT,delay)
		$Tween.interpolate_property($Sprite, "scale", Vector2(0,0), Vector2(2.5,2.5), durDelay_scale+delay,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$Tween.interpolate_property($Sprite, "modulate", Color(1,1,1,0) , Color(1,1,1,1), durDelay_scale,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$Tween.interpolate_property($Sprite, "modulate", Color(1,1,1,1) , Color(1,1,1,0), dur-durDelay_scale,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT,durDelay_scale)
		$Tween.interpolate_callback(self, dur + delay, "animEnd")
		$Tween.start()
	
func animEnd():
	queue_free()
