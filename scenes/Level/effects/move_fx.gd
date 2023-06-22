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

# Called when the node enters the scene tree for the first time.
func _ready():
	
	#all properties
	offset_start = $Sprite.position + Vector2(0,10)
	offset_end = $Sprite.position + Vector2(0,10)
	$Sprite.position = offset_end
	$Sprite.scale = scale_start
	
	#ready the animation
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
	
func animEnd():
	queue_free()
