extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var texture = $Viewport.get_texture()
	if is_instance_valid(texture):
		$Screen.texture = texture
		$Viewport/Spatial.set("Transparent BG",true)	
	pass
