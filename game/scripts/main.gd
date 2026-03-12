extends Node

var LevelIndex = GameEnums.Level
@onready var Main = $Main
@onready var level_environment = $World2D
@onready var ui_environment = $UiEnvironment

var uses_signals = true
var thread: Thread

var loaded_resource: PackedScene = null
#var loading_screen: PackedScene = null


func _ready():
	#print("Main: LevelIndex: ", LevelIndex)
	#print("Main: LevelIndex.LEVEL_!:", LevelIndex.LEVEL_1)
	load_level(LevelIndex.TEST_MENU)

func change_level(level_enum: int):
	var loaded_level = _load_level_scene(level_enum)
	get_tree().change_scene_to_packed(loaded_level)

#	ResourceLoader can be used asynchronously. Using load() stops the thread completely until the load is ready.
#	Callaa:	Main._load_level_scene(Main.LevelIndex.LEVEL_1) tai (GameEnums.Level.LEVEL_1)


func load_level(level_name: int):
	clear_current_level()
	var level_scene = _load_level_scene(level_name)
	var level_instance = level_scene.instantiate()
	level_environment.add_child(level_instance)


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
	for element in ui_environment.get_children():
		element.queue_free()


func on_command_signal(id, command, data):
	match id:
		"Main":
			match command:
				"load_level":
					load_level(data)

	