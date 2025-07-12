extends Control

var uses_signals = true
var signal_id = "settings_menu"#	vaihda settings_menu
@export var active = false

var settings = SettingsManager.SettingsData.adjustable_settings

var settings_checkbox = preload("res://ses/menu manager/scenes/global menus/settings menu/settings elements/checkbox_element.tscn")
var settings_slider = preload("res://ses/menu manager/scenes/global menus/settings menu/settings elements/slider_element.tscn")
var settings_dropdown = preload("res://ses/menu manager/scenes/global menus/settings menu/settings elements/dropdown_element.tscn")


#@export var settings_slider: PackedScene
#@export var settings_dropdown: PackedScene

@onready var game_page = $%game_list
@onready var video_page = $%video_list
@onready var sound_page = $%sound_list
@onready var controls_page = $%controls_list

func _ready() -> void:
#tsekkaa toimiiko listat oikein vaikka olisi aluksi piilossa
	if active == false:
		self.hide()
	for setting in settings:
		match setting["element"]:
			"checkbox":
				create_checkbox(setting)

			"slider":
				create_slider(setting)

			"dropdown":
				create_dropdown(setting)

func _process(_delta: float) -> void:	#delta turha?
	if Input.is_action_just_pressed("ui_cancel"):
		if active == true:
			close_menu()





func create_checkbox(setting):
	var checkbox_scene = settings_checkbox.instantiate()


	#var main = checkbox_instance.get_node("CheckBoxNode")
	#var label = checkbox_instance.get_node("%Label") #ei toimi

	var checkbox = checkbox_scene.get_node("CheckBox")

	#label.text = setting["display_name"]
	checkbox.text = setting["display_name"]
	print(checkbox)
	checkbox.set_pressed(setting["current"])

	checkbox.toggled.connect(Callable(self, "_on_checkbox_toggled").bind(setting))
	var address = define_address(setting)
	address.add_child(checkbox_scene)


func create_slider(setting):
	var slider_scene = settings_slider.instantiate()
	slider_scene.setting_id = setting["id"]	#	Laita myös muihin
	slider_scene.var_type = setting["var_type"]

	var label = slider_scene.get_node("Label")
	var slider = slider_scene.get_node("Slider")

	label.text = setting["display_name"]

	print(slider)
	slider.set_value(setting["current"])

	var address = define_address(setting)
	address.add_child(slider_scene)


func create_dropdown(setting):
	var dropdown_scene = settings_dropdown.instantiate()


	var label = dropdown_scene.get_node("Label")
	var dropdown = dropdown_scene.get_node("OptionButton")

	label.text = setting["display_name"]

	for option in setting["options"]:
		dropdown.add_item(option)
		
	var address = define_address(setting)
	print(dropdown)
	address.add_child(dropdown_scene)


func define_address(s):
	match s["category"]:
		"game":
			return game_page
		"video":
			return video_page
		"sound":
			return sound_page
		"controls":
			return controls_page

func _on_checkbox_toggled(pressed, setting):
	setting["current"] = pressed
	print("Checkbox toggled: ", setting["display_name"], " to ", pressed)


func on_ui_signal(id, cmd, data):
	if id != signal_id:
		return
	else:
		match cmd:
			"open":
				open_menu()
			"close":
			############################################
				close_menu()

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

func _on_return_button_pressed() -> void:
	print("returnbutton signal recieved")
	SignalManager.send_ui("menu_manager", "toggle", "pause")
