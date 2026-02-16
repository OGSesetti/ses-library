extends Node


func _colorize_text(color:int, text:String):
	var color_start := "[color=white]"
	var color_end := "[/color]"
	match color:
		Enums.TextColor.WHITE:
			color_start = "[color=white]"
		Enums.TextColor.RED:
			color_start = "[color=red]"
		Enums.TextColor.YELLOW:
			color_start = "[color=yellow]"
		Enums.TextColor.GREEN:
			color_start = "[color=green]"
		Enums.TextColor.BLUE:
			color_start = "[color=blue]"
		Enums.TextColor.PINK:
			color_start = "[color=pink]"
		_:
			color_start = "[color=white]"

	var colorized_text = color_start + text + color_end
	return colorized_text


func print_color(color:int, text: String):
	var result = _colorize_text(color, text)
	print(result)


func log(color:int, source_name: String, data_1 = "", data_2 = "", data_3 = "", data_4 = "", data_5 = ""):
	var bracketed_source
	match SesConfig.log_brackets:
		Enums.Brackets.ROUND:
			bracketed_source = "(" + source_name + ")"
		Enums.Brackets.SQUARE:
			bracketed_source = "[" + source_name + "]"
		Enums.Brackets.CURLY:
			bracketed_source = "{" + source_name + "}"

	var result = _colorize_text(color, bracketed_source)
	print_rich(result, " ", data_1, " ", data_2, " ", data_3, " ", data_4, " ", data_5)


func error():
	print_rich("[color=red] Warning:[/color] This is a warning")


func warning():
	print_rich("[color=yellow] Warning:[/color] This is a warning")


func success():
	print_rich("[color=green] Warning:[/color] This is a warning")


func save_json(data, path: String):
	var file = FileAccess.open(path, FileAccess.WRITE)
	if file == null:
		printerr("JSON save error")
		return false

	if data is String:
		file.store_string(data)
	else:
		file.store_string(JSON.stringify(data, "\t"))	#	 "\t" means pretty!
	#	file.store_string(data)	#

	file.close()
	return true
	

func save_json_to_folder(data, folder_path, file_name):
	var path = folder_path + file_name
	return save_json(data, path)


func load_json(path):
	if not FileAccess.file_exists(path):
		printerr("JSON load error: file not found. Path: ", path)
		return null

	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		printerr( "JSON load error: File failed to open: ", file)
		return null

	var content := file.get_as_text()
	file.close()

	var result = JSON.parse_string(content)
	if result == null:
		printerr("JSON parse error at: ", path)
		create_backup(content, path)
		return null
	return result


func load_json_from_folder(folder_path, file_name):
	var path = folder_path + file_name
	return load_json(path)


func create_backup(data, original_path):
	var basename = original_path.get_basename()
	var extension = original_path.get_extension()
	var dt = get_datetime_string_formatted()
	var filename = basename + "_" + dt + extension
	var new_path = SesConfig.backup_path + filename
	
	return save_json(data, new_path)


"""
var file_name = path.get_file()						# "my_save.json"
var file_base = file_name.get_basename()			# "my_save"
var file_ext = file_name.get_extension()			# "json"
var dir_path = path.get_base_dir()					# "user://saves"

"""

func get_datetime_string_formatted(utc: bool = false):
	var dt = Time.get_datetime_dict_from_system(utc)
	var dt_str: String = "%04d-%02d-%02dT%02d-%02d-%02d" % [
		dt.year, dt.month, dt.day,	dt.hour, dt.minute, dt.second
	]
	return dt_str

"""
#SaveManager
#	Muuta näitä nyt jumalauta
var res = SaveManager.res

func manual_save(s = ""):
	SaveManager.save_game(s)

func load_save(s = ""):
	SaveManager.load_game(s)

func auto_save():
	SaveManager.auto_save()

func save_res_set(k : String, v):
	SaveManager.set_res_value(k, v)

func save_res_set_var(k, v):
	SaveManager.set_res_variable(k, v)

func save_res_read(k: String):
	return res.get(k)

func save_res_read_var(k):
	return res.variables.get(k)

#/SaveManager


#MenuManager

func pause_game():
	SignalManager.send_ui("menu_manager", "toggle", "pause")
	print("Ses-library: Game paused")

func resume_game():
	SignalManager.send_ui("menu_manager", "toggle", "none")
	print("Ses-library: Game resumed")

func open_settings():
	SignalManager.send_ui("menu_manager", "toggle", "settings")

#/MenuManager
"""