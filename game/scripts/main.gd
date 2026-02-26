extends Node

@export var level_list: Dictionary
@onready var world2D = $World2D
@onready var gui = $Gui


var loading_screen: PackedScene = null
var loaded_resource: PackedScene = null


func _ready():
	set_process(false)


func load_level(level_path: String):
	var new_load_screen = loading_screen.instantiate()
	add_child(new_load_screen)
func _clear_level():
	pass

func change_level(level_path: String):
	_clear_level()
	load_level(level_path)