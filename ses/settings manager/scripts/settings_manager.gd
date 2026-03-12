extends Node
#	Signals
var uses_signals = true
var signal_id = "settings"

#	Saving
var res_path = FilePaths.settings_res_path
var save_path = FilePaths.settings_save_path

@export var default_settings: SettingsList
var runtime_settings: SettingsList
var SettingsData: Array


var last_edited: int = 0

#	Audio
var vol_bus_name = "Volume"
var sfx_bus_name = "SFX"
var music_bus_name = "Music"

var bus_index = [0, 0, 0]	# bus indexes

#var bus_index: int


func _ready() -> void:
	_get_bus_i()
	_crank_it()
	

func _crank_it():
	default_settings = ResourceLoader.load(res_path)
	runtime_settings = default_settings.duplicate(true)
	SettingsData = runtime_settings.list
	load_settings()
	

func load_settings():
	var loaded_res = _load_tres_file()
	if loaded_res is SettingsList:
		_load_values_from_file(loaded_res)
	else:
		print("Why the fuck is this erroring here??")


func _load_tres_file():
	var loaded_res: Resource = ResourceLoader.load(save_path)
	if loaded_res == null: # TEST THIS SHIT
		Ses.log(2, "SettingsManager", "Settings file not found. Creating one...")
		var result = create_save_data()
		if result == OK:
			Ses.log(3, "SettingsManager", "Success..?")
			loaded_res = _load_tres_file()
			return loaded_res
		else:
			Ses.log(1, "SettingsManager", "FATAL ERROR: Save file for settings not accessible. Check 'FilePaths.settings_save_path' or contact the developer.")
			Ses.create_dump_file("FATAL ERROR: Save file for settings not accessible. Check 'FilePaths.settings_save_path' or contact the developer.")
			get_tree().quit(1)
			return null

	elif loaded_res is not SettingsList:
		print(loaded_res.resource_name)
		Ses.log(2, "SettingsManager", "Settings file was found but is either corrupt or not in the expected format. Rewriting...")
		var result = create_save_data()
		if result == OK:
			print("Should definitely be ok")###############################	SHITS ITSELF
			var new_loaded_res = _load_tres_file()
			return new_loaded_res
		else:
			return null
	else:#	It's dumb I know
		Ses.log(4, "SettingsManager", "Settings file found. Loading...")
		return loaded_res

func _load_values_from_file(loaded_res):
	var default_setting_counter: int = 0
	var saved_setting_counter: int = 0
	for i in SettingsData:
		default_setting_counter = default_setting_counter + 1
		for n in loaded_res.list:
			#print(i.id, " - ", n.id)
			if i.id == n.id:
				i.current_value = n.current_value
				Ses.log(0, "SettingsManager", "Loaded: ", i.id, ": ", i.current_value)
				saved_setting_counter = saved_setting_counter + 1
				#break
	Ses.log(3, "SettingsManager", "Successfully loaded", saved_setting_counter, "out of", default_setting_counter, "settings")
	return

func create_save_data():
	DirAccess.remove_absolute(save_path)
	var result:int = ResourceSaver.save(default_settings, save_path)
	return result

func save_settings():
	var result:int = ResourceSaver.save(runtime_settings, save_path)
	return result

func set_setting(s: Setting, value):
	edit_setting_from_id(s.id, value)


func get_setting_from_id(setting_id: String):
	for s in SettingsData:
		if s.id == setting_id:
			print("Get_setting: ", s)
			return s
		return null


func edit_setting_from_id(setting_id, value):
	var s = get_setting_from_id(setting_id)
	s.current_value = value


func print_settings():
	for s in SettingsData:
		Ses.log(0, "SettingsData", s.id, "-", s.current_value)


#	AUDIO
func _get_bus_i():
	bus_index[0] = AudioServer.get_bus_index(vol_bus_name)
	bus_index[1] = AudioServer.get_bus_index(sfx_bus_name)
	bus_index[2] = AudioServer.get_bus_index(music_bus_name)


func additional_functionality(setting:Setting):#	Toistaiseksi suht turha mutta tulee varmaan käyttöön kun rupeaa koodaamaan muita asetuksia esim. resoluutiota
	match setting.id:
		"master_vol":
			var busi = 0
			change_bus_volume(setting, busi)

		"sfx_vol":
			var busi = 1
			change_bus_volume(setting, busi)			

		"music_vol":
			var busi = 2
			change_bus_volume(setting, busi)
		_:
			pass


func change_bus_volume(setting: Setting, busi:int):
	var volume: float = setting.current_value
	AudioServer.set_bus_volume_db(bus_index[busi], linear_to_db(volume))
