class_name basic_textContWithHeader

extends Node2D


# Declare member variables here. Examples:
var text_header = ""
var text_context = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	$lbl_header.text = text_header
	$lbl_content.text = text_context
	pass # Replace with function body.

func setHeader(nText):
	if nText != text_header:
		$lbl_header.text = nText + " : "
		text_header = nText
	
func setContent(nText):
	if nText != text_context:
		$lbl_content.text = nText
		text_context = nText

func getSize() -> float:
	if $lbl_content && text_context.length():
		var th = $lbl_content.rect_position.y + $lbl_content.rect_size.y
#		print(str($lbl_content.text) + str($lbl_content.rect_size))
		return th
	return 0.0
