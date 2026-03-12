extends Control

var assigned_setting: CheckBoxSetting
@onready var name_label = $%NameLabel
@onready var checkbox = $%CheckBox

func _ready() -> void:
	#print(assigned_setting.id, " Checkbox should be: ", assigned_setting.current_value)
	apply_settings()

func apply_settings():
	set_block_signals(true)
#	print("Current value: ",assigned_setting.current_value)
	checkbox.button_pressed = assigned_setting.current_value
#	print("Checkbox name: ", assigned_setting.display_name)
#s	print("Checkbox: ",name_label)
	checkbox.text = assigned_setting.display_name
	set_block_signals(false)


func _on_check_box_toggled(toggled_on:bool) -> void:
	assigned_setting.current_value = toggled_on
#	print(assigned_setting.display_name)
	name_label.text = assigned_setting.display_name
