extends Node

var path : String = "res://ses/save_files/"
var save_1_name : String = "save_1.json"
var save_2_name : String = "save_2.json"
var save_3_name : String = "save_3.json"
var save_1 : String
var save_2 : String
var save_3 : String


var data = {}
var loaded_save

func _ready() -> void:
	init_files(data)

func new():
	pass
	
func save():
	pass

func check_save_file(save_x):
	if FileAccess.file_exists(save_x):
		loaded_save = FileAccess.open(save_x, FileAccess.READ)
		
func create_save_path(selected_save_file):
	var full_path = path + selected_save_file
	return full_path

func init_files(data: Dictionary):
	save_1 = create_save_path(save_1_name)
	save_2 = create_save_path(save_2_name)
	save_3 = create_save_path(save_3_name)
	
	var files = [save_1, save_2, save_3]
	
	for file in files:
		if FileAccess.file_exists(file):
			pass
		else:
			FileAccess.open(file, FileAccess.WRITE)
			data["timestamp"] = Time.get_unix_time_from_system()
			#file.store_string(JSON.print(data))
			file.close()
			
			
func compare_file_ages():
	var files = [save_1, save_2, save_3]
	var newest_time = 0
	var newest_file
	var oldest_time = INF
	var oldest_file
	
	for file in files:
		if FileAccess.file_exists(file):
			var modified_time = FileAccess.get_modified_time(file)
	pass
