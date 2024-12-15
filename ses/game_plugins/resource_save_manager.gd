class_name SaveGame
extends Resource

const local_folder = SesConfig.save_folder_path
const auto_save_path : String = "autosave.tres"
const manual_save_path : String = SesConfig.save_folder_path

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
	
static func write_save_game(): #vittu unohda koko static
	#ResourceSaver.save()
	pass
	
func create_path():
	pass
