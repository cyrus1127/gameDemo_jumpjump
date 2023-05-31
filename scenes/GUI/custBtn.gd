extends TextureButton


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var inputName = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func press_input_action(_action: String, _strength: = 1.0):
	var input_action: = InputEventAction.new()
	input_action.action = _action
	input_action.pressed = true
	input_action.strength = _strength
	Input.parse_input_event(input_action)

func release_input_action(_action: String):
	var input_action: = InputEventAction.new()
	input_action.action = _action
	input_action.pressed = false
	input_action.strength = 0.0
	Input.parse_input_event(input_action)


func _on_button_down():
	if inputName.length() :
		press_input_action(inputName)
	pass # Replace with function body.

func _on_button_release():
	if inputName.length() :
		release_input_action(inputName)
	pass # Replace with function body.
