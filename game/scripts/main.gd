extends Node

var LevelIndex = GameEnums.Level
#@onready var Main = $self
#@onready var level_environment = $%World2D
#@onready var ui_environment = $%UiEnvironment
#@onready var menu_manager = $%MenuManager

var main
var level_environment
var ui_environment
var menu_manager

var uses_signals = true
var thread: Thread

var loaded_resource: PackedScene = null


func _ready():
	main = self
	level_environment = $World2D
	ui_environment = $UiEnvironment
	menu_manager = $%MenuManager

	ui_environment.mouse_filter = Control.MOUSE_FILTER_IGNORE
	menu_manager.mouse_filter = Control.MOUSE_FILTER_IGNORE
	load_menu(Game.menu_test_menu)


func change_level(level_enum: int):
	var loaded_level = _load_level_scene(level_enum)
	get_tree().change_scene_to_packed(loaded_level)



func load_level(level_name: String):
	clear_all()
	var level_scene = load(level_name)
	var level_instance = level_scene.instantiate()
	level_environment.add_child(level_instance)

func load_menu(menu_name: String):
	clear_all()
	var menu_scene: PackedScene = load(menu_name)
	var menu_instance = menu_scene.instantiate()
	ui_environment.add_child(menu_instance)

func _load_menu_scene(menu_enum: int):
	var menu_path = Game.menu[menu_enum]
	var menu
	if menu_path != null:
		menu = load(menu_path)
	else:
		Ses.log(1,"Main","Error loading menu_enum: path for menu_enum enum", menu_enum, "does not exist")
		return
	if menu is PackedScene:
		return menu


func _load_level_scene(level_enum: int):
	var level_path = Game.level[level_enum]
	var level
	if level_path != null:
		level = load(level_path)
	else:
		Ses.log(1,"Main","Error loading level: path for level enum", level_enum, "does not exist")
		return
	if level is PackedScene:
		return level


func clear_current_level():
	for child in level_environment.get_children():
		child.queue_free()


func clear_current_menu():
	for element in ui_environment.get_children():
		element.queue_free()


func clear_all():
	clear_current_level()
	clear_current_menu()


func on_command_signal(id, command, data):
	match id:
		"Main":
			match command:
				"load_level":
					load_level(data)
				"load_menu":
					load_menu(data)
	
