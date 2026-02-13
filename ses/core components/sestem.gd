extends Node
"""
func _log(type, message, data = null):
	pass
"""
enum colorenum{
	WHITE,
	RED,		# Think of traffic lights!
	YELLOW,
	GREEN,		# And now forget it!
	BLUE,
	PINK,
}






func log(color:int, source_name, data_1 = "", data_2 = "", data_3 = "", data_4 = "", data_5 = ""):
	var color_start := "[color=white]"
	var color_end := "[/color]"
	match color:
		colorenum.WHITE:
			color_start = "[color=white]"
		colorenum.RED:
			color_start = "[color=red]"
		colorenum.YELLOW:
			color_start = "[color=yellow]"
		colorenum.GREEN:
			color_start = "[color=green]"
		colorenum.BLUE:
			color_start = "[color=blue]"
		colorenum.PINK:
			color_start = "[color=pink]"
		_:
			color_start = "[color=white]"

	print_rich(color_start, "{", source_name, "}", color_end, " ", data_1, " ", data_2, " ", data_3, " ", data_4, " ", data_5)


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