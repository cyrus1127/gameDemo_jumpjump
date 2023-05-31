extends Area2D
signal player_in
signal player_out

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_dropAbleArea2D_body_entered(body):
	var player := body as KinematicBody2D
	if not player: 
		return
	else:
		print("dropAbleArea player entered")
		emit_signal("player_in")
	pass # Replace with function body.


func _on_dropAbleArea2D_body_exited(body):
	var player := body as KinematicBody2D
	if not player: 
		return
	else:
		print("dropAbleArea player exited")
		emit_signal("player_out")
	pass # Replace with function body.
