extends Control

var settings = SettingsManager.SettingsData.adjustable_settings

var settings_checkbox = preload("res://ses/menu_manager/menus/settings_elements/checkbox_element.tscn")
var settings_slider = preload("res://ses/menu_manager/menus/settings_elements/slider_element.tscn")

#@export var settings_slider: PackedScene
#@export var settings_dropdown: PackedScene

@onready var game_page = $%game_list
@onready var video_page = $%video_list
@onready var sound_page = $%sound_list
@onready var controls_page = $%controls_list

func _ready() -> void:
	for setting in settings:
		match setting["type"]:
			"checkbox":
				create_checkbox(setting)
				pass

			"slider":
				create_slider(setting)

			"dropdown":
				pass


func create_checkbox(setting):
	var checkbox_scene = settings_checkbox.instantiate()


	#var main = checkbox_instance.get_node("CheckBoxNode")
	#var label = checkbox_instance.get_node("%Label") #ei toimi

	var checkbox = checkbox_scene.get_node("CheckBox")

	#label.text = setting["name"]
	checkbox.text = setting["name"]
	print(checkbox)
	checkbox.set_pressed(setting["current"])

	checkbox.toggled.connect(Callable(self, "_on_checkbox_toggled").bind(setting))
	var address = define_address(setting)
	address.add_child(checkbox_scene)

func create_slider(setting):
	var slider_scene = settings_slider.instantiate()


	#var main = checkbox_instance.get_node("CheckBoxNode")
	#var label = checkbox_instance.get_node("%Label") #ei toimi

	var label = slider_scene.get_node("Label")
	var slider = slider_scene.get_node("Slider")

	label.text = setting["name"]


	print(slider)
	slider.set_value(setting["current"])

	#slider.toggled.connect(Callable(self, "_on_checkbox_toggled").bind(setting))
	var address = define_address(setting)
	address.add_child(slider_scene)









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
	print("Checkbox toggled: ", setting["name"], " to ", pressed)
