class_name LoadingCover
extends Node2D

signal tween_mid
signal tween_ended
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var dur = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite.set("scale",Vector2(0,1))
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func startAnimShow(delay:float = 0):
	$Tween.interpolate_property($Sprite,"scale", Vector2(0,1), Vector2(1,1),dur,Tween.TRANS_CUBIC,Tween.EASE_IN_OUT, delay)
	$Tween.interpolate_callback(self,(dur + delay)/2,"tweenMid")
	$Tween.interpolate_callback(self,(dur + delay),"tweenEnded")
	$Tween.start()
	pass

func startAnimHide(delay:float = 0):
#	$Sprite.set("scale",Vector2(1,1))
	$Tween.interpolate_property($Sprite,"scale", Vector2(1,1), Vector2(0,1),dur,Tween.TRANS_CUBIC,Tween.EASE_IN,delay)
	$Tween.interpolate_callback(self,(dur + delay),"tweenHideEnded")
	$Tween.start()
	pass

func tweenEnded():
	emit_signal("tween_ended")
	
func tweenMid():
	emit_signal("tween_mid")
	
func tweenHideEnded():
	queue_free()
