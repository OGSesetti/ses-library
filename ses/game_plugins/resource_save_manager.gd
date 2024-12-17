class_name SaveGame
extends Resource

const local_folder_path = SesConfig.save_folder_path
const user_folder_path = SesConfig.user_folder_path
const auto_save_name : String = "autosave.tres"
const manual_save_name : String = SesConfig.save_folder_path
const enable_user_directory = SesConfig.enable_user_directory
const manual_save_name : String = SesConfig.manual_save_name

var save_folder : String
var save_1 : String
var save_2 : String
var save_3 : String

#possible things to save
@export var current_level = ""
@export var inventory = Resource
@export var common_variables = {}

static func load_save_game():
	pass
	
static func write_save_game(auto_save : bool = false):
	var time_stamp = Time.get_date_string_from_system()
	var save_path = user_folder_path
	#ResourceSaver.save()
	pass
	
func create_path():
	pass
