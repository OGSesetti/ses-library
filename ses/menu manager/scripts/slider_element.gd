extends Control

var assigned_setting: SliderSetting
@onready var label = $%NameLabel
@onready var slider = $%Slider
"""
func _ready() -> void:
	set_block_signals(true)
	slider.set_value_no_signal(assigned_setting.current_value)
	label.text = assigned_setting.display_name
	set_block_signals(false)
"""
func _ready() -> void:
	slider.value = assigned_setting.current_value
	label.text = assigned_setting.display_name


func _on_slider_value_changed(value:float) -> void:
	assigned_setting.current_value = value
#	print("SliderElement: ",assigned_setting.id," set at: ",assigned_setting.current_value)
