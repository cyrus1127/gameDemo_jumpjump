extends Area2D

signal player_in_Shop
signal player_leave_Shop

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite.hide()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_ItemShop_body_entered(body):
	if checkIsPlayer(body):
		emit_signal("player_in_Shop")
		$AnimatedSprite.show()
	pass # Replace with function body.

func _on_ItemShop_body_exited(body):
	if checkIsPlayer(body):
		emit_signal("player_leave_Shop")
		$AnimatedSprite.hide()
	pass # Replace with function body.


func checkIsPlayer(body):
	return body as KinematicBody2D
	pass
