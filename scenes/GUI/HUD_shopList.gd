extends Node2D

signal shop_closed
signal item_selected

enum CateType{
	Recover,
	Equipment,
	All
}

# Declare member variables here. Examples:
var items_data_all = {
  "values": [
	{  "name": "Wine",  "price": 20,  "type": "Recover"},
	{  "name": "Apple",  "price": 3,  "type": "Recover"},
	{  "name": "Beer",  "price": 10,  "type": "Recover"},
	{  "name": "Bread",  "price": 5,  "type": "Recover"},
	{  "name": "Cheese",  "price": 7,  "type": "Recover"},
	{  "name": "Fish Steak",  "price": 18,  "type": "Recover"},
	{  "name": "Green Apple",  "price": 2,  "type": "Recover"},
	{  "name": "Ham",  "price": 12,  "type": "Recover"},
	{  "name": "Meat",  "price": 25,  "type": "Recover"},
	{  "name": "Mushroom",  "price": 8,  "type": "Recover"},
	{  "name": "Wine 2",  "price": 17,  "type": "Recover"}
	
	,{  "name": "Wine",  "price": 20,  "type": "Recover"},
	{  "name": "Apple",  "price": 3,  "type": "Recover"},
	{  "name": "Beer",  "price": 10,  "type": "Recover"},
	{  "name": "Bread",  "price": 5,  "type": "Recover"},
	{  "name": "Cheese",  "price": 7,  "type": "Recover"},
	{  "name": "Fish Steak",  "price": 18,  "type": "Recover"},
	{  "name": "Green Apple",  "price": 2,  "type": "Recover"},
	{  "name": "Ham",  "price": 12,  "type": "Recover"},
	{  "name": "Meat",  "price": 25,  "type": "Recover"},
	{  "name": "Mushroom",  "price": 8,  "type": "Recover"},
	{  "name": "Wine 2",  "price": 17,  "type": "Recover"}
  ]
}



# Called when the node enters the scene tree for the first time.
func _ready():
	changeListedItem(CateType.Recover)
	pass # Replace with function body.

func changeListedItem(n_type : int):
	#do clear all existing development items from list before add new
	$item_info_rect/ScrollContainer/VScrollBar/ItemList.clear()
	
	#load item list
	var imagePath = "res://res/Texture/Food/"
	var imageExtension = ".png"
	var allItems := items_data_all["values"] as Array
	if allItems:
		for n in allItems.size():
			var texturePath = imagePath + allItems[n].name + imageExtension
#			var image = Image.load_from_file(texturePath)
			var texture = load(texturePath)
#			var texture = ImageTexture.new().create_from_image(image)
			
			$item_info_rect/ScrollContainer/VScrollBar/ItemList.add_item("", texture ,true)
		
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_TextureButton_pressed():
	hide()
	emit_signal("shop_closed")
	pass # Replace with function body.


func _on_ItemList_item_selected(index):
	emit_signal("item_selected",index)
	pass # Replace with function body.


func _on_VScrollBar_changed():
	print("_on_VScrollBar_changed")
	pass # Replace with function body.
