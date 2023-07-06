extends Node2D


# Declare member variables here. Examples:
var max_hp = 100
var cur_hp = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func setVal(nName , nHP):
	$Label.text = nName
	
	max_hp = nHP
	cur_hp = nHP
	$ProgressBar.max_value = max_hp
	$ProgressBar.value = cur_hp
	pass

func updateCurHP(nHP):
	cur_hp = nHP
	$ProgressBar.value = cur_hp
	pass

func showWithTween():
	set("modulate",Color(1,1,1,0))
	show()
	$Tween.interpolate_property(self, "modulate", Color(1,1,1,0) , Color(1,1,1,1), 3,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
