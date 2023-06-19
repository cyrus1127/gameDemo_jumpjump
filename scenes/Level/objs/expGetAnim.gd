class_name ExpGetAnim
extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var start_pos = 0
var dur = 3

# Called when the node enters the scene tree for the first time.
func _ready():
	start_pos = $Label.rect_position
	
	pass # Replace with function body.

func startWithText(nAmount):
	$Label.text = "+"+ str(nAmount) + " exps"
	startAnim()

func startAnim():
	
	var end_pos = $Label.rect_position - Vector2(0, 100)
	
	$Tween.interpolate_property($Label, "rect_position", start_pos, end_pos, dur,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.interpolate_property($Label, "modulate", Color(1,1,1,1) , Color(1,1,1,0), dur,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.interpolate_callback(self,dur, "animEnded")
	$Tween.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func animEnded():
	print("tween end")
#	queue_free()
