extends Control

var uses_signals = true
var signal_id = "menu_manager"

var active_menu = 0

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE


func _process(_delta: float) -> void:	#delta turha?
	if Input.is_action_just_pressed("ui_cancel"):
		global_menu_toggle_input()




func global_menu_toggle_input():
	match active_menu:
		0:
			SignalManager.send_ui("pause_menu", "open")
			active_menu = 1
		1:
			SignalManager.send_ui("pause_menu", "close")
			active_menu = 0
		2:
			SignalManager.send_ui("settings_menu", "close")#	add the save and quit shit to the settigns menu script
			active_menu = 1


func on_ui_signal(id, cmd, data):
	if id != signal_id:
		pass
	else:
		match cmd:
			"toggle":
				toggle(data)
			"menu_button_input":
				global_menu_toggle_input()


func toggle(m):

	match m:
		"pause":
			SignalManager.send_ui("pause_menu", "open")
			SignalManager.send_ui("settings_menu", "close")
			active_menu = 1

		"settings":
			SignalManager.send_ui("pause_menu", "open")
			SignalManager.send_ui("settings_menu", "open")
			active_menu = 2

		"null", "none", "":
			SignalManager.send_ui("pause_menu", "close")
			SignalManager.send_ui("settings_menu", "close")
			active_menu = 0