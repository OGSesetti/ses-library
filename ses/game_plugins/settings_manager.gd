extends Node

var path = SesConfig.settings_path
var SettingsData = SettingsResource.new()
var current_settings

func _ready() -> void:
	init_file()


func save_settings():
	ResourceSaver.save(SettingsData, path)
	update_settings()


func load_settings():
	SettingsData = ResourceLoader.load(path)
	update_settings()


func update_settings():
	SignalManager.send_command("settings", "update")


func init_file():
	var loaded_res = ResourceLoader.load(path)
	if loaded_res:
		save_settings()
	else:
		print("SettingsManager: Settings file not found. Creating one.")
		load_settings()
	pass