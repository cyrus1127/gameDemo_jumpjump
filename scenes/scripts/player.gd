extends RigidBody2D
signal hit

# Declare member variables here. Examples:
export var speed = 400
var screen_size
var velocity = Vector2()
# Add this variable to hold the clicked position.
var target = Vector2()
var isStarted = false

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	$AnimatedSprite.play()
	pass # Replace with function body.

func start(pos):
	position = pos
	target = pos
	isStarted = true
	show()
	$CollisionShape2D.disabled = false
	pass

func _input(event):
	if event is InputEventScreenTouch and event.pressed && isStarted:
		print(event.position)
#		target = event.position
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if Input.is_action_just_pressed("ui_right"):
		velocity.x = 1
	if Input.is_action_just_pressed("ui_left"):
		velocity.x = -1
#	if position.distance_to(target) > 10: #A touch handle
#		velocity.x = target.x - position.x
	
	if Input.is_action_just_released("ui_right") || Input.is_action_just_released("ui_left") || (velocity.x > -1 && velocity.x < 1):
		$AnimatedSprite.animation = "idle"
		velocity = Vector2();
	else:
		if velocity.x != 0 || velocity.y != 0:
			$AnimatedSprite.animation = "run"	
			$AnimatedSprite.flip_h = velocity.x < 0
			
		
	# move itself
	position += (velocity.normalized() * speed) * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
pass


func _on_Player_body_entered(body):
	var _class = body.get_class()
	print("body entered , body class is " + _class)
	if(_class == "RigidBody2D"):
		hide()
		emit_signal("hit")
		isStarted = false
		$CollisionShape2D.set_deferred("disable",true)
	
	pass # Replace with function body.
