extends Node


#	SaveManager
const folder_name : String = "saves" 		#	Located in users://
const auto_save_name: String = "autosave"	#	Can be changed without worries
const manual_save_name : String = "Save" 	#	Time stamp and filetype are added in the code
const check_overwrite : bool = true 		#	Does nothing right now
#	/SaveManager

#	SettingsManager
const settings_path = "res://ses/settings_save/settings.tres"	#	Probably a good idea to not touch this
#	/SettingsManager