extends CanvasLayer

var tile_size:int = 32
var file:File = File.new()
var file_path:String
var scene_index:int = 0
var stage_index:int = 0
var last_stage_reach:int = 0
var stage_max:int = 10
var scene_name:String = "main"
var dead_scene:PackedScene = preload("res://scenes/title.tscn")
var esc_scene:PackedScene = preload("res://scenes/title.tscn")
var scene_fade:Node
var savePath:String = "user://savedata.bin"
var passPhrase:String = "OkdfPooie0029?/dll"
var current_music:String = ""
var music_isOn = true
var playerData : PlayerData
const playerObjName = "Player_RigidBody2D"

var items_data_all = {
  "values": [
	{  "name": "Wine", "detail":"this is food. Recover HP 20", "price": 20,  "type": "Recover", "recoverType":"hp", "value":20},
	{  "name": "Apple", "detail":"this is food. Recover HP 20", "price": 3,  "type": "Recover", "recoverType":"hp", "value":20},
	{  "name": "Beer", "detail":"this is food. Recover HP 20", "price": 10,  "type": "Recover", "recoverType":"hp", "value":20},
	{  "name": "Bread", "detail":"this is food. Recover HP 20", "price": 5,  "type": "Recover", "recoverType":"hp", "value":20},
	{  "name": "Cheese", "detail":"this is food. Recover HP 20", "price": 7,  "type": "Recover", "recoverType":"hp", "value":20},
	{  "name": "Fish Steak", "detail":"this is food. Recover SP 20", "price": 18,  "type": "Recover", "recoverType":"sp", "value":20},
	{  "name": "Green Apple", "detail":"this is food. Recover SP 20", "price": 2,  "type": "Recover", "recoverType":"sp", "value":20},
	{  "name": "Ham", "detail":"this is food. Recover SP 20", "price": 12,  "type": "Recover", "recoverType":"sp", "value":20},
	{  "name": "Meat", "detail":"this is food. Recover SP 20", "price": 25,  "type": "Recover", "recoverType":"sp", "value":20},
	{  "name": "Mushroom", "detail":"this is food. Recover SP 20", "price": 8,  "type": "Recover", "recoverType":"sp", "value":20},
	{  "name": "Wine 2", "detail":"this is food. Recover SP 20", "price": 17,  "type": "Recover", "recoverType":"sp", "value":20}
  ]
}

# for debug only
func _ready():
	print("[Screen Metrics]")
	print("Display size: ", OS.get_screen_size())
	print("Decorated Window size: ", OS.get_real_window_size())
	print("Window size: ", OS.get_window_size())
	print("Project Settings: Width=", ProjectSettings.get_setting("display/window/size/width"), " Height=", ProjectSettings.get_setting("display/window/size/height"))
	print(OS.get_window_size().x)
	print(OS.get_window_size().y)
	playerData = PlayerData.new()
	stage_index = 0 
	load_game()

func _process(delta) -> void:
	# MENU ESC
	if not GLOBAL.scene_name in ["intro"]: # , "title"
		var esc:bool = Input.is_action_just_pressed("ui_cancel")
	
#		if esc && !get_tree().paused:
#			get_tree().paused = true
#			var e = esc_scene.instance()
#			get_node("/root").add_child(e)
#
#		elif esc && get_tree().paused:
#			get_tree().paused = false
#			if has_node("/root/esc_scene"):
#				get_node("/root/esc_scene").queue_free()

func restart_scene() -> void:
#	yield(get_tree().create_timer(1), "timeout")
#
#	scene_fade = scene_fade_out(.5)
#	yield(scene_fade, "tween_completed")
#
#	file_path = "res://scenes/level"+str(stage_index)+".tscn"
#	if file.file_exists(file_path):
#		get_tree().change_scene(file_path)
#
#	scene_fade = scene_fade_in(.5)
#	yield(scene_fade, "tween_completed")
#	$color.hide()
#	get_tree().paused = false
	pass

func back_to_title(var dataSave : bool = false ) -> void:
	_next_scene("title")
	if dataSave:
		save_game()
	


func next_scene() -> void:
	
	scene_index += 1
	if scene_index%5 == 0:
		_next_scene("shop")
	else :
		_next_scene("level")
	pass

func _next_scene(scene:String = "", fade_out:float = 1, fade_in:float = .5) -> void:
	scene_name = scene
		
	scene_fade = scene_fade_out(fade_out)
#	yield(scene_fade, "tween_completed")
	yield(get_tree().create_timer(fade_out),"timeout")
	
	if scene == "" || scene == "level":
		file_path = "res://scenes/Level/level"+str(stage_index + 1)+".tscn"
		if file.file_exists(file_path):
			save_game()
			stage_index += 1
			get_tree().change_scene(file_path)
		else:
			stage_index = 0
			scene_index = 0
			get_tree().change_scene("res://scenes/title.tscn")
	elif scene == "shop":
		get_tree().change_scene("res://scenes/Level/level_safe.tscn")
	elif scene == "title":
		stage_index = 0
		scene_index = 0
		get_tree().change_scene("res://scenes/title.tscn")
	else:
		file_path = "res://scenes/"+scene+".tscn"
		if file.file_exists(file_path):
			get_tree().change_scene(file_path)
		else:
			print('scene not exists')

	scene_fade = scene_fade_in(fade_in)
#	yield(scene_fade, "tween_all_completed")
	yield(get_tree().create_timer(fade_in),"timeout")
	$color.hide()
	get_tree().paused = false

func scene_fade_out(time:float) -> Tween:
	get_tree().paused = true
	return scene_fade(0, 1, time)

func scene_fade_in(time:float) -> Tween:
	return scene_fade(1, 0, time)

func scene_fade(start:int, end:int, time:float) -> Tween:
	$color.modulate = Color(0,0,0,start)
	$color.show()

	var tween = Tween.new()
	tween.stop_all()
		
	tween.interpolate_property($color, "modulate", Color(0,0,0,start), Color(0,0,0,end), time, Tween.TRANS_LINEAR, Tween.EASE_IN)
	if tween.start() :
		print("tween started")
	
	return tween


# =-=-=-=-=-=-=-- Player data save/load handling
func player_dead() -> void:
#	var player = get_node("/root/scene/player")
#
#	if player:
#		var d = dead_scene.instance()
#		d.position = player.position
#		get_node("/root/scene").add_child(d)
#
#		player.queue_free()
#
#		$sfx/sfx_dead.play()
	pass

func save_game() -> void:
	file.open_encrypted_with_pass(savePath, File.WRITE, passPhrase)

	var datas:Dictionary = {}
	datas.level = last_stage_reach 
	datas.playerData = playerData.getDataDic()

	file.store_string(JSON.print(datas))
	file.close()

func load_game() -> void:
	if !file.file_exists(savePath):
		stage_index = 0

	else:
		file.open_encrypted_with_pass(savePath, File.READ, passPhrase)
		var datas = parse_json(file.get_as_text())
		file.close()

		last_stage_reach = datas.level
		for k in datas.keys():
			if k == "playerData":
				playerData.dataRestore(datas[k])

		GLOBAL.scene_name = "level"

		GLOBAL.change_music("music_level")

		restart_scene()
	

# https://docs.godotengine.org/en/3.0/tutorials/misc/handling_quit_requests.html
func _notification(what) -> void:
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
			get_tree().quit() # default behavior

func change_music(node_name:String, delay:float = 1) -> void:
#	if !GLOBAL.get_node("sfx/"+node_name).is_playing():
#		GLOBAL.get_node("sfx/"+node_name).play()
#
#	if current_music != "" && current_music != node_name:
#		$tween_music.interpolate_property(GLOBAL.get_node("sfx/"+current_music), "volume_db", GLOBAL.get_node("sfx/"+current_music).volume_db, -80, 1, Tween.TRANS_LINEAR, 0)
#		$tween_music.interpolate_property(GLOBAL.get_node("sfx/"+node_name), "volume_db", GLOBAL.get_node("sfx/"+node_name).volume_db, 0, delay, Tween.TRANS_LINEAR, 0)
#
#	$tween_music.start()
#	current_music = node_name
	pass

func change_sfx(node_name:String, delay:float = 1) -> void:
	if !GLOBAL.get_node("sfx/"+node_name).is_playing():
		GLOBAL.get_node("sfx/"+node_name).play()
#
	pass
	
func musicOnOff() -> void:
	music_isOn = !music_isOn




# =-=-=-=-=-=-=-=-  Tween transation event function
func _on_Tween_tween_started(object, key):
	print("tween start run")
	pass # Replace with function body.

func _on_Tween_tween_completed(object, key):
	print("tween run finished ")
	pass # Replace with function body.
