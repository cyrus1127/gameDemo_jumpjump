extends GameObj
signal coin_hit

# Declare member variables here. Examples:

# Called when the node enters the scene tree for the first time.
func _ready():

	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_body_entered(body):
	var player := body as KinematicBody2D
	if not player: 
		return
	else:
		print("coin : player in")
		emit_signal("coin_hit", self)
		GLOBAL.change_sfx("coin")
		$Sprite.hide()
		$CollisionShape2D.queue_free()
		$Particles2D.restart()
	pass # Replace with function body.

