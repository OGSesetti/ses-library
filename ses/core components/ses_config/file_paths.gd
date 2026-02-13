@tool
extends Node


#	SaveManager
#	Folder and file names are separated for save_manager for easier file naming.
@export var save_folder_name : String = "saves" 		#	Located in users://
@export var auto_save_name: String = "autosave"	#	Can be changed without worries
@export var manual_save_name : String = "Save" 	#	Time stamp and filetype are added in the code
@export var check_for_overwrite : bool = true 		#	Does nothing right now
#	/SaveManager


#	SettingsManager

@export var settings_res_path: String = "res://ses/settings manager/res/SettingsSource.tres"
@export var settings_save_path: String = "user://settings.tres"
#	/SettingsManager


#	AudioManager
@export var audio_manager_scene_path: String = "res://ses/audio manager/scenes/audio_manager.tscn"
@export var audio_file_path: String = "res://game assets/audio/"
@export var audio_resource_path: String = "res://ses/audio manager/sound_effect_resources/"
#	/AudioManager


#	MusicManager
@export var music_manager_path: String = "res://ses/music manager/scenes/music_manager.tscn"
@export var music_file_path: String = "res://game assets/audio/music/"
@export var music_resource_path: String = "res://ses/music manager/music_resources/"
#	/MusicManager