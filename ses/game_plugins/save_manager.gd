class_name SaveGame
extends Resource

var path = SesConfig.save_path
const auto_save_name: String = "autosave.json"
const manual_save_name = SesConfig.manual_save_name
const check_overwrite = SesConfig.check_overwrite


var json = JSON.new()

#possible things to save
@export var settings = {}
@export var inventory = Resource #possibly no
@export var root_dict = {
	"default_dict" = {}
}
	


#TODO
#declare return values


func new_variable(key: String, value, address : String = "default_dict") -> bool:
	var dict = get_dictionary(address)
	if dict.has(key):
		push_error("Variable in selected address already exists.")
		return false
	else:
		dict[key] = value
		return(true)



func update_variable(key: String, value, address : String = "default_dict") -> bool:
	var dict = get_dictionary(address)
	dict[key] = value
	return(true)



func delete_variable(key: String, address : String = "default_dict") -> bool:
	var dict = get_dictionary(address, false)
	if dict == !null:
		if dict.has(key):
			dict.remove(key)
			return true
		else:
			push_error("Variable in selected address wasn't found.")
			return(false)
	else:
		push_error("Dictionary: ", address, " doesn't exist.")
		return(false)


func get_dictionary(dict_name: String, create_new : bool = true):
	if root_dict.has(dict_name):
		var dictionary = root_dict[dict_name]
		return(dictionary)
	else:
		if create_new == true:
			print("SaveManager.get_dictionary: Dictionary: ", dict_name, " doesn't exist. Creating one.")
			root_dict[dict_name] = {}
			var dict = root_dict[dict_name]
			return(dict)
		else:
			return null



func clear_dictionary(dict_name: String) -> bool:
	if root_dict.has(dict_name):
		root_dict[dict_name] = {}
		return(true)
	else:
		push_error("Dictionary: ", dict_name, " doesn't exist.")
		return(false)


func load_save(save_name : String) -> bool:
	var file_path = path + save_name
	var file
	if FileAccess.file_exists(file_path):
		file = FileAccess.open(file_path, FileAccess.READ)
		var error = json.parse(file)
		if error == OK:
			var save_data = json.data
			if typeof(save_data) == TYPE_DICTIONARY:
				root_dict = save_data
				return true
			else:
				push_error("Parsed data from ", save_name, " is not a dictionary.")
				return false
		else:
			push_error("Failed to parse JSON data.")
			return false
	else:
		push_error("File: ", file_path, " doesn't exist.")
		return false



func write_save(data : Dictionary = root_dict, name = manual_save_name) -> bool:
	var save_data = JSON.stringify(data)
	var time_stamp = Time.get_date_string_from_system()
	var file_name = name + "-" + time_stamp + ".json"
	var file = FileAccess.open(path + file_name, FileAccess.WRITE)
	file.store_string(save_data)
	file.close()
	if FileAccess.file_exists(path + file_name):
		return(true)
	else:
		return(false)


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
			print("save_manager:  fetched ",  counter, " files unsorted.")
		1:
			file_names.sort_custom(func(a, b): return a[timestamp] > b[timestamp])
			print("save_manager:  fetched ",  counter, " files sorted by newest to oldest.")
		2:
			file_names.sort_custom(func(a, b): return a[timestamp] < b[timestamp])
			print("save_manager:  fetched ",  counter, " files sorted by oldest to newest.")
	return file_names
