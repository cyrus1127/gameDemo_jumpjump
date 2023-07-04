class_name emit_bullet
extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var speed = 300
var direct_right = true
var hited = false
var isFired = false
var dur = 1.5

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite.set("modulate",Color(1,1,1,0))
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !hited && isFired: 
		if direct_right :
			position += Vector2(speed *delta , 0)
		else:
			position += Vector2(-speed *delta , 0)
		
		if dur - delta < 0 :
			isFired = false
			queue_free()
		else :
			dur -= delta
	pass

# =-=-=-=-=-=- public call functions

func fire(isToRight):
	if !isFired :
		isFired = true
		direct_right = isToRight
		
		#handle flip
		$AnimatedSprite.flip_h = !direct_right
		if !direct_right:
			$CollisionPolygon2D.rotation_degrees = 180
		
		#tween the oppisity
		$Tween.interpolate_property($AnimatedSprite, "modulate", Color(1,1,1,0) , Color(1,1,1,1), 1,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$Tween.start()
	pass


# =-=-=-=-=-=-=-=- delegate

func _on_Area2D_body_entered(body):
	var player := body as KinematicBody2D
		
	if !hited && player && player.name.match(GLOBAL.playerObjName): 
		player.onHit()
		hited = true
		queue_free()
	pass # Replace with function body.
