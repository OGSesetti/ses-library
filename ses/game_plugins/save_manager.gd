extends Node
class_name SaveGame

const root_path = "user://"
var folder_name = SesConfig.folder_name
const auto_save_name: String = SesConfig.auto_save_name 	#	ONE SAVE ONLY: always uses the same name and overwrites itself
const manual_save_name: String = SesConfig.manual_save_name #	UNLIMITED SAVES: adds a timestamp to create an unique name
const check_overwrite = SesConfig.check_overwrite 			#	Doesn't do anything right now

var res = SaveResource.new()
var json = JSON.new()
var files_list
var path

var exclude_keys = [

#	All keys related to the inner workings of the Resource need to be excluded. 
#	Otherwise they get saved to the JSON as empty values. Loading a save will then delete
#	everything related to identifying that Resource, which makes the whole system shit itself.

"resource_name",
"resource_path",
"resource_local_to_scene",
"script",
"resource_scene_unique_id",
"RefCounted",
"Resource",
"save_resource.gd"

]

func _ready() -> void:
	init_folder()
	files_list = get_files()

func init_folder():
	if not folder_name.ends_with("/"):
		folder_name = folder_name + "/"

	path = root_path + folder_name
	var dir = DirAccess.open(root_path)
	if dir == null:
		push_error("Can't find user path")
		print("SaveManager: can't find ", root_path)
	if dir.dir_exists(path):
		print("Save folder found")
	else:
		if dir.make_dir(path) == OK:
			print("Save folder not found. Creating one at: ", path)
		else:
			push_error("Failed to find or create save folder")
			print("SaveManager: ERROR: could not find or create save folder. Fuck.")

func save_game(n = manual_save_name, autosave : bool = false): #	I guess you can save without the timestamp with (name, true) 
	if n.strip_edges() == "":
		n = manual_save_name
	var file_name
	var timestamp
	var data = {}
	for property in res.get_property_list():
		var key = property.name
		if key not in exclude_keys:
			data[key] = res.get(key)
			print("SaveManager: ", key, " added to package")
	var json_data = JSON.stringify(data, "\t") #	\t means pretty text

	if autosave == false:	
		timestamp = Time.get_datetime_string_from_system()
		timestamp = timestamp.replace(":", "-").replace("T", " - ")
		file_name = n + " - " + timestamp
	else:
		file_name = n + ".json"

	var file = FileAccess.open(path + file_name, FileAccess.WRITE)
	print("SaveManager: game saved at ", path, file_name)
	file.store_string(json_data)
	file.close()
	files_list = get_files()



func auto_save():
	save_game(auto_save_name, true)
	pass


func load_game(n: String = auto_save_name):
	if n == "":
		n = auto_save_name
	n = n + ".json"
	var data
	var file = FileAccess.open(path + n, FileAccess.READ)
	print("SaveManager: attempting to load: ", path, n)

	if not file:
		push_error("Could not find file: ", n)
		print("SaveManager: ERROR: save file not found")
		return(false)

	var json_data = file.get_as_text()
	#print(json_data)
	var error_status = json.parse(json_data)

	if error_status == OK:
		data = json.data
		print("SaveManager: parse successful.")
	else:
		push_error("Error parsing JSON-data.")
		print("SaveManager: ERROR parsing JSON.")

	for key in data.keys():
		#print(key)
		if key in res:
			res.set(key, data[key])
			print("SaveManager: ", key, " set to ", "'", res.get(key),"'")
		else:
			print("SaveManager: ", key, " not found in res. Skipping. If every variable is giving you this shit, check the exclude_keys -array at SaveManager.")
			pass
	print("SaveManager: load successful")
	files_list = get_files()
	return res


func get_files(type : int = 1): #	0 == no sorting, 1 == newest to oldest, 2 == oldest to newest
	var file_names = []
	var dir = DirAccess.open(path)
	#print("print(dir): ", dir)
	#print("dir.get_current_dir(): ", wtf)
	var timestamp
	var counter : int = 0
	if dir == null:
		print("Directory not found.")
		return(false)

	dir.list_dir_begin()

	while true:
		var current_item = dir.get_next()
		if current_item == "":
			break

		timestamp = FileAccess.get_modified_time(path + "/" + current_item)
		var save_info = {"Name": current_item, "Timestamp": timestamp}
		
		#leave out all folders and autosave
		if !dir.current_is_dir():
			if current_item != auto_save_name + ".json":
				file_names.append(save_info)
				print("SaveManager: ", current_item, " found")
				counter += 1

	
	match type:
		0:
			print("SaveManager: fetched ",  counter, " files unsorted")
		1:
			file_names.sort_custom(func(a, b): return a["Timestamp"] > b["Timestamp"])
			print("SaveManager: fetched ",  counter, " files sorted newest to oldest")
		2:
			file_names.sort_custom(func(a, b): return a["Timestamp"] < b["Timestamp"])
			print("SaveManager: fetched ",  counter, " files sorted oldest to newest")
	return file_names


func set_res_value(k : String, v):
	if k in res:
		var p = res.get(k)
		res.set(k, v)
		print("SaveManager: variable '", k, "' has been set from '", p, "' to '", v, "'")
	else:
		push_error("Variable ", k, " not found in SaveResource.")
		print("SaveManager: variable '", k, "' not found in SaveResource.")


func set_res_variable(k, v):
	var d = res.get("variables")
	if typeof(d) != TYPE_DICTIONARY:
		print("Error: ", d, " is not a Dictionary.")
		push_error("Variables is either not dictionary or not defined.")

	if d.has(k):
		d[k] = v
		print(d)
		print("SaveManager: variable '", k, "' set to '", v, "'")
	else:
		d[k] = v
		print(d)
		print("SaveManager: variable '", k , "' added with set value of '", v, "'")
