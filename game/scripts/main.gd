extends Node

@onready var world2D = $World2D
#@onready var gui = $Gui

var thread: Thread

var loaded_resource: PackedScene = null
#var loading_screen: PackedScene = null



#	ResourceLoader can be used asynchronously. Using load() stops the thread completely until the load is ready.
func load_level(level_name):
	var level_path = GameObject.level[level_name]
	if level_path != null:
		load(GameObject.levels[level_name])
	else:
		Ses.log(1,"Main","Error loading level:", level_name, "")




"""


func load_level_from_path(level_path: String):
	var result = _load_level_not_in_thread(level_path)
	if result != 0:
		Ses.log(1, "Main", "ERROR Loading level at path:", level_path)
		return
	else:
		get_tree().change_scene_to_packed(loaded_resource)


func load_level(level_name: String):
	var level_path = get_level_path(level_name)
	if level_path != null and level_path is String:
		var	result = _load_level_not_in_thread(level_path)
		if result != 0:
			Ses.log(1, "Main", "ERROR Loading level at path:", level_path)
			return
		else:
			get_tree().change_scene_to_packed(loaded_resource)


func _load_level_not_in_thread(level_path: String):#	ResourceLoader can be used asynchronously. load() stops the thread
	print("Thread inactive")
	var _loaded_resource = ResourceLoader.load(level_path)
	if !_loaded_resource:
		return Error.ERR_FILE_NOT_FOUND
	if _loaded_resource is not PackedScene:
		return Error.ERR_FILE_UNRECOGNIZED
	else:
		loaded_resource = _loaded_resource
		return Error.OK
"""





"""
func _ready():
	thread = Thread.new()


func load_level(level_path: String):
	var result = thread.start(_load_level_in_thread.bind(level_path))
	if result != 0:
		Ses.log(1, "Main", "ERROR Loading level at path:", level_path)
		return
	else:
		get_tree().change_scene_to_packed(loaded_resource)


func _load_level_in_thread(level_path: String):
	print("Thread active")
	var _loaded_resource = ResourceLoader.load(level_path)
	if !_loaded_resource:
		return Error.ERR_FILE_NOT_FOUND
	if _loaded_resource is not PackedScene:
		return Error.ERR_FILE_UNRECOGNIZED
	else:
		loaded_resource = _loaded_resource
		return Error.OK
"""