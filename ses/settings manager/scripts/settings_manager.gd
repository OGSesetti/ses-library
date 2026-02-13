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

var busi = [0, 0, 0]	# bus indexes

var bus_index: int


func _ready() -> void:
	_init()


func _init():
	default_settings = ResourceLoader.load(res_path)
	runtime_settings = default_settings.duplicate(true)
	SettingsData = runtime_settings.list

	"""
	var loaded_res = ResourceLoader.load(save_path)
	if loaded_res:
		load_settings()
		print("SettingsManager: Loaded settings")
	else:
		print("SettingsManager: Settings file not found. Creating one.")
		save_settings()
	pass
"""




func load_settings():
	Ses.log(0, "SettingsManager", "Attempting to load settings...")
	var loaded_res = ResourceLoader.load(save_path)

	if not loaded_res: # TEST THIS SHIT
		Ses.log(2, "SettingsManager", "Settings file not fount. Creating one...")
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
			if i.id == n.id:
				i = n
				saved_setting_counter = saved_setting_counter + 1
	Ses.log(3, "SettingsManager", "Successfully loaded", saved_setting_counter, "out of", default_setting_counter, "settings")


func save_settings():
	ResourceSaver.save(runtime_settings, save_path)


func update_settings():
	SignalManager.send_command("settings", "update_nodes")#	Tarkista


func get_setting(setting_id):
	for i in SettingsData:
		if i.id == setting_id:
			return runtime_settings[i]["current"]
	return null


func edit_setting(setting_type, setting, new_value):
	#match setting_type:

	pass

"""
func set_setting(data):
	if current_settings[last_edited]["id"] == data[0]:
		current_settings[last_edited]["current"] = data[1]
		additional_functionality(data)
	else:
		for i in runtime_settings.size():
			if runtime_settings[i]["id"] == data[0]:
				runtime_settings[i]["current"] = data[1]
				last_edited = i
				print(runtime_settings[i])
				additional_functionality(data)
"""

func get_busi():
	busi[0] = AudioServer.get_bus_index(vol_bus_name)
	busi[1] = AudioServer.get_bus_index(sfx_bus_name)
	busi[2] = AudioServer.get_bus_index(music_bus_name)


func change_volume():
	pass
	

func on_command_signal(id, cmd, data = ""):
	if id != signal_id:
		return
	else:
		match cmd:
			"set":
				set_setting(data)
				additional_functionality(data)
				#update_settings()

			"update":
				update_settings()
			
			"save":
				save_settings()
				print("SettingsManager: Received command: Save")
				
			_:
				pass



func update_all():
	for i in current_settings.size():
		update_from_memory_by_address_int(i)


func update_from_memory_by_address_int(i: int):	#mikä vittu tää on
	var data = []
	data[0] = current_settings[i]["id"]
	data[1] = current_settings[i]["current"]
	additional_functionality(data)


func update_from_memory_by_id(id: String):#	Not in use right now
	for i in runtime_settings.size():
		if runtime_settings[i]["id"] == id:
			var data = [id, i["current"]]
			additional_functionality(data)


func additional_functionality(data):
	match data[0]:
		"vol", "sfx", "music":
			update_audio(data)
		_:
			print("SettingsManager: Error at function: additional_functionality. setting_id: ", data[0], " was not recognized")


func update_audio(data):
	match data[0]:
		"vol":
			var vol = float(data[1])
			AudioServer.set_bus_volume_db(busi[1], linear_to_db(vol))
			print("Master volume changed to ", vol)

		"sfx":
			var vol = float(data[1])
			AudioServer.set_bus_volume_db(busi[1], linear_to_db(vol))

		"music":
			var vol = float(data[1])
			AudioServer.set_bus_volume_db(busi[2], linear_to_db(vol))

		_:
			pass
