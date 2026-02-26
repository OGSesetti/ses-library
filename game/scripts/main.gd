extends Node

@onready var world2D = $World2D
#@onready var gui = $Gui

var thread: Thread

var loaded_resource: PackedScene = null
#var loading_screen: PackedScene = null



#func _ready():
#	thread = Thread.new()


func load_level(level_path: String):
	var result = _load_level_not_in_thread(level_path)
	if result != 0:
		Ses.log(1, "Main", "ERROR Loading level at path:", level_path)
		return
	else:
		get_tree().change_scene_to_packed(loaded_resource)


func _load_level_not_in_thread(level_path: String):
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