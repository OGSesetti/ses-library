extends Control

var assigned_setting: CheckBoxSetting
@onready var name_label = $%NameLabel
@onready var checkbox = $%CheckBox

func _ready() -> void:
	#print(assigned_setting.id, " Checkbox should be: ", assigned_setting.current_value)
	apply_settings()

func apply_settings():
	set_block_signals(true)
#	assigned_setting = SettingsManager.get_setting_from_id(assigned_setting.id)
	print("Current value: ",assigned_setting.current_value)
	checkbox.button_pressed = assigned_setting.current_value
	print("Checkbox name: ", assigned_setting.display_name)
	print("Checkbox: ",name_label)
	checkbox.text = assigned_setting.display_name
	set_block_signals(false)


func _on_check_box_toggled(toggled_on:bool) -> void:
	assigned_setting.current_value = toggled_on
	print(assigned_setting.display_name)
	name_label.text = assigned_setting.display_name







"""
extends Control

var assigned_setting: CheckBoxSetting
#@onready var name_label = $%Label
@onready var checkbox = $%CheckBox

func _ready() -> void:
	set_block_signals(true)
	checkbox.button_pressed = assigned_setting.current_value
	name_label.text = assigned_setting.display_name
#	print(assigned_setting.id, " value: ", assigned_setting.current_value)
	set_block_signals(false)


#func _on_check_box_toggled(toggled_on:bool) -> void:
#	SettingsManager.SettingsData.assigned_setting.current_value = toggled_on

func _physics_process(_delta):
	if assigned_setting.id == "cfc":
		checkbox.set_pressed_no_signal(assigned_setting.current_value)
		print("ID: ", assigned_setting.id, " Setting value: ", assigned_setting.current_value)
	pass


#func _on_check_box_toggled(toggled_on:bool) -> void:
#	assigned_setting.current_value = toggled_on


#func _on_check_box_pressed() -> void:
#	assigned_setting.current_value = checkbox.button_pressed
	

func _on_check_box_button_down() -> void:
	assigned_setting.current_value = checkbox.button_pressed
"""