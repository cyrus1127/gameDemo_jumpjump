extends "res://scenes/scripts/level_logic.gd"

export (PackedScene) var dropItem



func genItem():
	print("drop items")
	pass


# =-=-=-=-=- override functions =-=--=-=-=-=-
func addTrap():
	print("in Training room currently, auto gen trap & monster function is disabled")
	pass

func deductPlayHP(d_HP):
	if gameStart :
#		player_hp -= d_HP
		$Player_RigidBody2D.onHit()
		$HUD_level.update_hp(player_hp)
		if player_hp <= 0: # give reset
			$HUD_level.showDeadView(false)
	pass


# =-=-=-=-=- signal functions =-=--=-=-=-=-

func _on_TraggerBtn_player_traggered( id ):
	print("traggerBtn "+ str(id)+" is traggered")
	
	match(id):
		0:
			genMob($Path2D_monster/PathFollow2D)
		1:
			if boss_cnt < max_boss:
				boss_cnt += 1
				genMobBoss($Path_itemGen/PathFollow2D)
	
	pass # Replace with function body.
