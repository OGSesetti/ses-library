extends Node
#	Signals
var uses_signals = true
var signal_id = "settings"

#	Saving
var path = SesConfig.settings_path
var SettingsData = SettingsResource.new()
var current_settings = SettingsData.adjustable_settings
var last_edited: int = 0

#	Audio
var vol_bus_name = "Volume"
var sfx_bus_name = "SFX"
var music_bus_name = "Music"

var busi = [0, 0, 0]	# bus indexes

var bus_index: int



func _ready() -> void:
	init_file()
	get_busi()


func init_file():
	var loaded_res = ResourceLoader.load(path)
	if loaded_res:
		load_settings()	#	these used to be flipped
	else:
		print("SettingsManager: Settings file not found. Creating one.")
		save_settings()	#	.
	pass


func get_busi():
	busi[0] = AudioServer.get_bus_index(vol_bus_name)
	busi[1] = AudioServer.get_bus_index(sfx_bus_name)
	busi[2] = AudioServer.get_bus_index(music_bus_name)


func save_settings():
	ResourceSaver.save(SettingsData, path)
	update_settings()


func load_settings():
	SettingsData = ResourceLoader.load(path)
	update_settings()


func update_settings():
	SignalManager.send_command("settings", "update_nodes")#	Tarkista







func set_setting(data):
	if current_settings[last_edited]["id"] == data[0]:
		current_settings[last_edited]["current"] = data[1]
		additional_functionality(data)
	else:
		for i in current_settings.size():
			if current_settings[i]["id"] == data[0]:
				current_settings[i]["current"] = data[1]
				last_edited = i
				additional_functionality(data)


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
				pass
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
	for i in current_settings.size():
		if current_settings[i]["id"] == id:
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
