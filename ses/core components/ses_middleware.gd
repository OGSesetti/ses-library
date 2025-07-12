extends Node

#SignalManager

#/SignalManager



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
func res_inventory(): #NOT IMPLEMENTED
	pass


func ():
	pass

func ():
	pass

func ():
	pass

func ():
	pass

func ():
	pass

func ():
	pass

func ():
	pass

"""
