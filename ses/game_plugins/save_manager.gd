class_name SaveGame
extends Resource

const path = SesConfig.save_folder_path
const auto_save_name: String = "autosave.tres"
const manual_save_name = SesConfig.manual_save_name
const check_overwrite = SesConfig.check_overwrite

var save_folder: String
var save_1: String
var save_2: String
var save_3: String

var json = JSON.new()

#possible things to save
@export var current_level = ""
@export var inventory = Resource
@export var root_dict = {}
@export var save_history = []
	
func create_path():
	pass

func new_variable(key: String, value, address : Dictionary = root_dict):
	if address.has(key):
		push_error("ERROR at save.manager.new_variable: Variable already exists.")
		return(false)
	else:
		address[key] = value
		return(true)

func update_variable(key: String, value, address : Dictionary = root_dict):
		address[key] = value
		return(true)

func new_dictionary(key: String, address : Dictionary = root_dict, allow_overwrite = false):
	if address.has(key):
		if allow_overwrite == true:
			address[key] = {}
			return(true)
		else: # save_manager/SaveManager
			push_error("ERROR at save_manager.new_dictionary: Variable already exists and overwrite is turned off. Set true as third argument to bypass this.")
			return(false)
	else: # save_manager/SaveManager
		address[key] = {}
		return(true)


func load_save(save_name : String):	
	var file_path = path + save_name
	if FileAccess.file_exists(file_path):
		var file = FileAccess.open(file_path, FileAccess.READ)
	pass



func write_save(name = manual_save_name):
	#var path = define_path()
	var time_stamp = Time.get_date_string_from_system()
	var file_name = name + "-" + time_stamp + ".json"
	var file = FileAccess.open(path + file_name, FileAccess.WRITE)
	file.store_string(root_dict)
	file.close()
	save_history = [file_name]
	return(true)


func get_files(type : int = 1):
	var file_names = []
	var dir = DirAccess.open(path)
	var timestamp
	var counter : int = 0
	if dir == null:
		print("Directory not found.")
		return(false)

	while dir.get_next():
		var current_item = dir.get_next()
		timestamp = FileAccess.get_modified_time(current_item)
		var save_info = {"Name": current_item, "Timestamp": timestamp}
		if dir.current_is_file():
			file_names.append(save_info)
			counter += 1
	
	match type:
		0:
			pass
		1:
			file_names.sort_custom(func(a, b): return a[timestamp] > b[timestamp])
		2:
			file_names.sort_custom(func(a, b): return a[timestamp] < b[timestamp])
	print("save_manager:  fetched ",  counter, " files.")
	return file_names



#func define_path():
#	var path : String
#
#		path = user_folder_path
#	else:
#		path = local_folder_path
#	return(path)