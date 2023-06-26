class_name ItemObj
extends RigidBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var isEmitNeed = false
var times_hit_floor = 3
var myData = {  "name": "coin", "detail":"coin", "price": 1,  "type": "Coins", "value":100}

# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	_doOneTimeEmit()
	pass
	
func _doOneTimeEmit():
	if isEmitNeed:
		isEmitNeed = false
		apply_central_impulse(Vector2(-100 + randi() % 200, -100))
	else:
		if $Sprite.visible :
			apply_central_impulse(Vector2(0, 15))

func setOneTimeEmit():
	if !isEmitNeed :
		isEmitNeed = true

func playerPicked():
	GLOBAL.change_sfx("coin")
	$Sprite.hide()
	$CollisionShape2D.queue_free()
	$Particles2D.restart()
	
	yield(get_tree().create_timer(3), "timeout")
	queue_free()

func setItemDetail(data = null):
	
	if data != null : 
		myData = data
#	var type = data.type
	match (myData.type):
		"Coins":
			$Sprite.texture #change nothing
			print(" drop item be default  ")
		"Recover":
			$Sprite.texture = GLOBAL.getCommonItemTexture(myData.name)
		"Equipment":
			$Sprite.texture = GLOBAL.getEquipmentTexture(myData.name)
		"Weapon":
			$Sprite.texture = GLOBAL.getEquipmentTexture(myData.name, true)

func getdata():
	return myData


func _on_Area_floor_cast_body_entered(body):
	var tileType := body as TileMap
	if tileType :
		if times_hit_floor == 0:
			set_sleeping(true) 	
			call_deferred("set", "mode", MODE_STATIC)
			$Area_floor_cast.queue_free()
		else : 
			times_hit_floor -= 1

	pass # Replace with function body.
