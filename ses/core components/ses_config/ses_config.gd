@tool
extends Node

#	Sestem

@export var log_brackets: Enums.Brackets = Enums.Brackets.CURLY

#	SaveManager
@export var save_folder_name : String = "saves" 		#	Located in users://
@export var auto_save_name: String = "autosave"	#	Can be changed without worries
@export var manual_save_name : String = "Save" 	#	Time stamp and filetype are added in the code
@export var check_for_overwrite : bool = true 		#	Does nothing right now
#	/SaveManager

#	SettingsManager
@export var settings_path: String = "res://ses/settings manager/settings_save_folder/resources/settings.tres"	#	Probably a good idea to not touch this
#	/SettingsManager


#	SignalManager
@export var mute_standard_signals: bool = true
@export var mute_command_signals: bool = true
@export var mute_global_signals: bool = true
@export var mute_ui_signals: bool = true

#	/SignalManager

#	AudioManager
@export var audio_manager_path: String = "res://ses/audio manager/scenes/audio_manager.tscn"
@export var audio_file_path: String = "res://game assets/audio/"
@export var audio_resource_path: String = "res://ses/audio manager/sound_effect_resources/"

#	/AudioManager

#	MusicManager
@export var music_manager_path: String = "res://ses/music manager/scenes/music_manager.tscn"
@export var music_file_path: String = "res://game assets/audio/music/"
@export var music_resource_path: String = "res://ses/music manager/music_resources/"
#	/MusicManager