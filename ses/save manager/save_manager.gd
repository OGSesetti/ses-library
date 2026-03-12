extends Node
class_name SaveGame

const root_path = "user://"
var folder_name = SesConfig.save_folder_name
var auto_save_name: String = SesConfig.auto_save_name 	#	ONE SAVE ONLY: always uses the same name and overwrites itself
var manual_save_name: String = SesConfig.manual_save_name #	UNLIMITED SAVES: adds a timestamp to create an unique name
var check_overwrite = SesConfig.check_for_overwrite 			#	Doesn't do anything right now

var res = SaveResource.new()#	Väärin. Älä käytä tätä
var json = JSON.new()		#	...
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
		Ses.log(1, "SaveManager", "can't find", root_path)
	if dir.dir_exists(path):
		Ses.log(4, "SaveManager", "Save folder found")
	else:
		if dir.make_dir(path) == OK:
			Ses.log(2, "SaveManager", "Save folder not found. Creating one at:", path)
		else:
			Ses.log(1, "SaveManager", "ERROR: Could not find or create save folder. Fuck.")

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
			Ses.log(0, "SaveManager", key, "added to package")		
	var json_data = JSON.stringify(data, "\t") #	\t means pretty text

	if autosave == false:	
		timestamp = Time.get_datetime_string_from_system()
		timestamp = timestamp.replace(":", "-").replace("T", " - ")
		file_name = n + " - " + timestamp
	else:
		file_name = n + ".json"

	var file = FileAccess.open(path + file_name, FileAccess.WRITE)
	Ses.log(0, "SaveManager", "game saved at: ", path+file_name)
	file.store_string(json_data)
	file.close()
	files_list = get_files()



func auto_save():
	save_game(auto_save_name, true)


func load_game(n: String = auto_save_name):
	if n == "":
		n = auto_save_name
	n = n + ".json"
	var data
	var file = FileAccess.open(path + n, FileAccess.READ)
	Ses.log(0, "SaveManager", "attempting to load:", path+n)

	if not file:
		push_error("Could not find file: ", n)
		Ses.log(1, "SaveManager", "ERROR: Save file", n, "not found")
		return(false)

	var json_data = file.get_as_text()
	var error_status = json.parse(json_data)

	if error_status == OK:
		data = json.data
		Ses.log(3, "SaveManager", "parse successful")
	else:
		Ses.log(1, "SaveManager", "ERROR parsing JSON.")

	for key in data.keys():
		if key in res:
			res.set(key, data[key])
			Ses.log(0, "SaveManager", key, "set to", res.get(key))

		else:
			Ses.log(3, "SaveManager", key, "not found in res. Skipping. If every variable is giving you this shit, check the exclude_keys -array at SaveManager.")
			

	Ses.log(3, "SaveManager","load succesful")

	files_list = get_files()
	return res


func get_files(type : int = 1): #	0 == no sorting, 1 == newest to oldest, 2 == oldest to newest
	var file_names = []
	var dir = DirAccess.open(path)

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
				Ses.log(0, "SaveManager", current_item, "found")
				counter += 1

	
	match type:
		0:
			Ses.log(3, "SaveManager", counter, "fetched. Sort: none")
			print("SaveManager: fetched ",  counter, " files unsorted")
		1:
			file_names.sort_custom(func(a, b): return a["Timestamp"] > b["Timestamp"])
			Ses.log(3, "SaveManager", counter, "files fetched. Sort: new to old")
		2:
			file_names.sort_custom(func(a, b): return a["Timestamp"] < b["Timestamp"])
			Ses.log(3, "SaveManager", counter, "files fetched. Sort: old to new")
			
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