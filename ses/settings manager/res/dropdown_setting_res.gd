extends Setting
class_name DropdownSetting

var type = Enums.SettingType.DROPDOWN

@export var dropdown_options: Array[String]

@export var default_value: int
@export var current_value: int