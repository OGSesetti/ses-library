extends Control
# Right now button padding is done just by adding spaces to the left of the text. I don't want to bother to do it properly from the overrides, so keep this in mind when making themes/styles

var uses_signals = true
var signal_id = "pause_menu"

var active: bool = false



func _ready() -> void:
	self.hide()


func toggle_menu():
	if active == false:
		open_menu()
	else:
		close_menu()

func open_menu():
	get_tree().paused = true
	self.show()
	active = true

func close_menu():
	get_tree().paused = false
	self.hide()
	active = false

func _on_resume_pressed() -> void:
	SignalManager.send_ui("menu_manager", "toggle", "none")

func _on_settings_pressed() -> void:
	SignalManager.send_ui("menu_manager", "toggle", "settings")


func _on_exit_to_main_menu_pressed() -> void:
	get_tree().quit()


func on_ui_signal(id, cmd, data):
	if id != signal_id:
		return
	else:
		match cmd:
			"open":
				open_menu()
			"close":
				close_menu()