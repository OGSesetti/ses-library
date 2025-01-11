extends Node

var res = SaveManager.res

func save_manual(s = ""):
	SaveManager.save_game(s)

func save_load(s = ""):
	SaveManager.load_game(s)

func save_auto():
	SaveManager.auto_save()

func res_set(k : String, v):
	SaveManager.set_res_value(k, v)

func res_set_var(k, v):
	SaveManager.set_res_variable(k, v)

func res_read(k: String):
	return res.get(k)

func res_read_var(k):
	return res.variables.get(k)


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