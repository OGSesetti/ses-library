extends Control

var uses_signals = true
var signal_id = "settings_menu"#	vaihda settings_menu
@export var active = false

var SettingsData = SettingsList

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
	SettingsData = SettingsManager.SettingsData
	if active == false:
		self.hide()
	for setting in SettingsData:
		match setting.type:
			Enums.SettingType.CHECKBOX:
				create_checkbox(setting)

			Enums.SettingType.SLIDER:
				create_slider(setting)

			Enums.SettingType.DROPDOWN:
				create_dropdown(setting)




func _process(_delta: float) -> void:	#delta turha?
	if Input.is_action_just_pressed("ui_cancel"):
		if active == true:
			close_menu()





func create_checkbox(setting:CheckBoxSetting):
	var checkbox_scene = settings_checkbox.instantiate()#	Tämä scene sisältää variablen 'assigned_setting'
#	var checkbox = checkbox_scene.get_node("CheckBox")	#	Valitaan tästä scenestä yksittäinen objekti joka EI sisällä sitä
	checkbox_scene.assigned_setting = setting			#	Ja MuUtEtaaN sE vaRiabLe siELLä																stupid fuck
	var address = define_address(setting)
	address.add_child(checkbox_scene)


func create_slider(setting:SliderSetting):
	var slider_scene = settings_slider.instantiate()
	slider_scene.assigned_setting = setting
	var address = define_address(setting)
	address.add_child(slider_scene)


func create_dropdown(setting:DropdownSetting):
	var dropdown_scene = settings_dropdown.instantiate()
	dropdown_scene.assigned_setting = setting
	var address = define_address(setting)
	address.add_child(dropdown_scene)


func define_address(setting:Setting):
	match setting.category:
		Enums.SettingCategory.GAME:
			return game_page
		Enums.SettingCategory.VIDEO:
			return video_page
		Enums.SettingCategory.SOUND:
			return sound_page
		Enums.SettingCategory.CONTROLS:
			return controls_page



func on_ui_signal(id, cmd, _data):
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
	SignalManager.send_ui("menu_manager", "toggle", "pause")


func _on_save_button_pressed() -> void:
	SettingsManager.save_settings()
