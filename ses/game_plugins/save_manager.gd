class_name SaveGame
extends Resource

const local_folder_path = SesConfig.save_folder_path
const user_folder_path = SesConfig.user_folder_path
const auto_save_name: String = "autosave.tres"
const use_user_directory = SesConfig.use_user_directory
const manual_save_name = SesConfig.manual_save_name
const check_overwrite = SesConfig.check_overwrite

var save_folder: String
var save_1: String
var save_2: String
var save_3: String

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


func load_save(save_name):	
	var path : String
	if use_user_directory == true:
		path = user_folder_path
	else:
		path = local_folder_path



func write_save(name = manual_save_name):
	var path = define_path()
	var time_stamp = Time.get_date_string_from_system()
	var file_name = name + "-" + time_stamp + ".json"
	var file = FileAccess.open(path + file_name, FileAccess.WRITE)
	file.store_string(root_dict)
	file.close()
	save_history = [file_name]
	return(true)


#might not work
func get_files():
	var counter = 0
	var file_list : Dictionary = {}
	var path = define_path()
	for file_path in path:
		var file = FileAccess.open(file_path, FileAccess.READ)
		if file != null:
			var file_name = file_path.get_name()
			var mod_time = file_path.get_modified_time()
			counter += 1
			var key = counter.stringify()
			var data = {"Name": file_name,"Date": mod_time}
			file_list[key] = data
			file.close()
	return file_list


func define_path():
	var path : String
	if use_user_directory == true:
		path = user_folder_path
	else:
		path = local_folder_path
	return(path)