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
	get_bus_index()
	_init()
	print_settings()

func _init():
	default_settings = ResourceLoader.load(res_path)
	runtime_settings = default_settings.duplicate(true)
	SettingsData = runtime_settings.list
	load_settings()
	print(SettingsData)

func load_settings():
	Ses.log(0, "SettingsManager", "Attempting to load settings...")
	var loaded_res = ResourceLoader.load(save_path)

	if not loaded_res: # TEST THIS SHIT
		Ses.log(2, "SettingsManager", "Settings file not found. Creating one...")
		save_settings()
		load_settings()

	if loaded_res is not SettingsList:
		Ses.log(2, "SettingsManager", "Settings file was found but is either corrupt or not in the expected format. Rewriting...")
		save_settings()
		load_settings()

	Ses.log(3, "SettingsManager", "Settings file found. Loading...")

	var default_setting_counter: int = 0
	var saved_setting_counter: int = 0
	
	for i in SettingsData:
		default_setting_counter = default_setting_counter + 1
		for n in loaded_res.list:
			#print(i.id, " - ", n.id)
			if i.id == n.id:
				i.current_value = n.current_value
				Ses.log(4, "SettingsManager", "Loaded: ", i.id, ": ", i.current_value)
				saved_setting_counter = saved_setting_counter + 1
				#break
	Ses.log(3, "SettingsManager", "Successfully loaded", saved_setting_counter, "out of", default_setting_counter, "settings")
	return

func save_settings():
	ResourceSaver.save(runtime_settings, save_path)

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
func get_bus_index():
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
