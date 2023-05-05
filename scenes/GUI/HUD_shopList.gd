extends Node2D

signal shop_closed
signal item_selected
signal userInfo_changed

enum CateType{
	Recover,
	Equipment,
	All
}

# Declare member variables here. Examples:
var toLetAmt = 1
var toLetindex = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	changeListedItem(CateType.Recover)
	
	var allItems = getItems()
	if allItems:
		$item_info_rect/ScrollContainer/VScrollBar/ItemList.select(0)
		_on_ItemList_item_selected(0)
		toLetindex = 0
	
	pass # Replace with function body.

func getItems():
	var allItems := GLOBAL.items_data_all["values"] as Array
	return allItems

func changeListedItem(n_type : int):
	#do clear all existing development items from list before add new
	$item_info_rect/ScrollContainer/VScrollBar/ItemList.clear()
	
	#load item list
	var imagePath = "res://res/Texture/Food/"
	var imageExtension = ".png"
	var allItems = getItems()
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

func updateAmt():
	$Node_content/amt_/lbl_amt.text = str(toLetAmt)
	pass

func _on_TextureButton_pressed():
	hide()
	emit_signal("shop_closed")
	pass # Replace with function body.


func _on_ItemList_item_selected(index):
	emit_signal("item_selected",index)
	toLetindex = index
	toLetAmt = 1
	updateAmt()

	var allItems = getItems()
	if allItems:
		$Node_content/lbl_name.text = allItems[index].name
		$Node_content/lbl_detail.text = allItems[index].detail
		$Node_content
	
	pass # Replace with function body.


func _on_VScrollBar_changed():
	print("_on_VScrollBar_changed")
	pass # Replace with function body.


func _on_btn_amt_dec_button_down():
	if toLetAmt - 1 >= 1:
		toLetAmt -= 1
	updateAmt()
	pass # Replace with function body.


func _on_btn_amt_inc_button_down():
	if toLetAmt +1  <= 999:
		toLetAmt += 1
	updateAmt()
	pass # Replace with function body.


func _on_btn_buy_button_down():
	#{  "name": "Wine 2", "detail":"this is food. Recover SP 20", "price": 17,  "type": "Recover", "recoverType":"sp", "value":20 , "amt":0}
	var toBuyItemD = getItems()[toLetindex]
	
	#check balance
	if GLOBAL.playerData.balance - (toLetAmt * toBuyItemD.price ) >= 0 :
		if GLOBAL.playerData.items.size() == 0 :
			toBuyItemD["amt"] = toLetAmt
			GLOBAL.playerData.items.push_back(toBuyItemD)
			GLOBAL.change_sfx("buysell")
		else : 
			var findItem = null
			for extItem in GLOBAL.playerData.items :
				if extItem.name == toBuyItemD.name :
					findItem = extItem
					break
					
			if findItem:
				findItem.amt += toLetAmt
			else : #no existing item
				toBuyItemD["amt"] = toLetAmt
				GLOBAL.playerData.items.push_back(toBuyItemD)
			GLOBAL.change_sfx("buysell")
		GLOBAL.playerData.balance -= (toLetAmt * toBuyItemD.price )
		$HUD_node_msg_box.showMsg(toBuyItemD.name + " x" + str(toLetAmt) + " in your bag !")
		emit_signal("userInfo_changed")
	else :
		$HUD_node_msg_box.showMsg("balance not enough")
	
	
	toLetAmt = 1
	updateAmt()
	
	pass # Replace with function body.


