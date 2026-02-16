extends Control

var assigned_setting: DropdownSetting
@onready var label = $%Label
@onready var dropdown = $%OptionButton

func _ready():
	set_block_signals(true)
	add_options()
	dropdown.selected = assigned_setting.current_value
#	print("DropdownElement: set option ", assigned_setting.current_value, " as selected")
	label.text = assigned_setting.display_name
	set_block_signals(false)

func add_options():
	for option in assigned_setting.dropdown_options:
		dropdown.add_item(option)



func _on_option_button_item_selected(index:int) -> void:
	assigned_setting.current_value = index
