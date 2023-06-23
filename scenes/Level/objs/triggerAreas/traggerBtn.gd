class_name TraggerBtn
extends Node2D

signal player_traggered

# Declare member variables here. Examples:
# var a = 2
export var id = 0
var player_in = false
var avaible = true
var resetTime = 3 #sec
var resetTC = -1

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite.set_playing(false)
	$AnimatedSprite.set_frame(0)
	pass # Replace with function body.

func get_input():
	
	if player_in && avaible:
		if Input.is_action_pressed("ui_attack"):
			tragger()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	get_input()
	
	if resetTC >= 0 && !avaible:
		resetTC -= delta
		if resetTC < 0 :
			# reset this button
			$AnimatedSprite.set_playing(false)
			$AnimatedSprite.set_frame(0)
			avaible = true
			resetTC = -1
			
	pass

func tragger():
	if avaible :
		emit_signal("player_traggered",id)
		avaible = false
		resetTC = resetTime
		$AnimatedSprite.play()
	pass


func _on_TraggerBtn_body_entered(body):
	var player := body as KinematicBody2D
	if player && player.name.match(GLOBAL.playerObjName): 
		player_in = true
	pass # Replace with function body.
	

func _on_TraggerBtn_body_exited(body):
	var player := body as KinematicBody2D
	if player && player.name.match(GLOBAL.playerObjName): 
		player_in = false
	pass # Replace with function body.
