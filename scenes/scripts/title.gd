extends Node2D

export (PackedScene) var Mob
var score
#var level_1 = preload("res://scenes/Level/level1.tscn")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize() # make new seed for random
	
	pass # Replace with function body.



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func game_over():
	$Timer_score.stop()
	$Timer_mob.stop()
	
	$HUD.show_game_over()
	pass # Replace with function body.

func new_game():
	GLOBAL.next_scene()
	pass

func _on_Timer_start_timeout():
	$Timer_mob.start()
	$Timer_score.start()
	pass # Replace with function body.


func _on_Timer_score_timeout():
	score += 1
	$HUD.update_score(score)
	pass # Replace with function body.


func _on_Timer_mob_timeout():
	$Path_mob/PathFollow_mobSpawn.offset = randi()
	var mob = Mob.instance()
	add_child(mob)
	mob.position = $Path_mob/PathFollow_mobSpawn.position
	
	mob.linear_velocity = Vector2(rand_range(mob.min_speed, mob.max_speed), 0)
	
	pass # Replace with function body.

