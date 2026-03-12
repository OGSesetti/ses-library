extends Control

#SaveManager
@onready var manualSave = %manualSave
@onready var autoSave = %autoSave
@onready var loadSave = %loadSave
@onready var setResValue = %setResValue
@onready var setResVariable = %setResVariable

#SettingsManager
@onready var saveSettings = %saveSettings
@onready var loadSettings = %loadSettings
@onready var resetToDefaults = %resetToDefaults

#DialogueManager
@onready var playDialogue = %playDialogue

#MenuManager
@onready var openMainMenu = %openMainMenu
@onready var openSettingsMenu = %openSettingsMenu
@onready var openPauseMenu = %openPauseMenu

func _ready() -> void:
	manualSave.pressed.connect(Callable(self, "_on_button_pressed").bind("manualSave"))
	autoSave.pressed.connect(Callable(self, "_on_button_pressed").bind("autoSave"))
	loadSave.pressed.connect(Callable(self, "_on_button_pressed").bind("loadSave"))
	setResValue.pressed.connect(Callable(self, "_on_button_pressed").bind("setResValue"))
	setResVariable.pressed.connect(Callable(self, "_on_button_pressed").bind("setResVariable"))

	saveSettings.pressed.connect(Callable(self, "_on_button_pressed").bind("saveSettings"))
	loadSettings.pressed.connect(Callable(self, "_on_button_pressed").bind("loadSettings"))
	resetToDefaults.pressed.connect(Callable(self, "_on_button_pressed").bind("resetToDefaults"))

	playDialogue.pressed.connect(Callable(self, "_on_button_pressed").bind("playDialogue"))

	openMainMenu.pressed.connect(Callable(self, "_on_button_pressed").bind("openMainMenu"))
	openSettingsMenu.pressed.connect(Callable(self, "_on_button_pressed").bind("openSettingsMenu"))
	openPauseMenu.pressed.connect(Callable(self, "_on_button_pressed").bind("openPauseMenu"))

func _on_button_pressed(b: String):
	print(b)
	match b:
		"manualSave":#1
			SaveManager.save_game()

		"autoSave":#2
			SaveManager.auto_save()

		"loadSave":#3
			SaveManager.load_game()

		"setResValue":#4
			SaveManager.set_res_value("name", "Stonie")

		"setResVariable":#5
			SaveManager.set_res_variable("BigBoss", "Adam Richman")

		"saveSettings":#6
			pass

		"loadSettings":#7
			pass

		"resetToDefaults":#8
			pass

		"playDialogue":#9
			pass

		"openMainMenu":#10
			pass

		"openSettingsMenu":#11
			SignalManager.send_ui("settings", "open")

		"openPauseMenu":#12
			pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


#func _on_open_pause_menu_pressed() -> void:
#	pass # Replace with function body.


func _on_load_level_pressed() -> void:
	Main.load_level(LevelIndex.Level1)


func _on_exit_pressed() -> void:
	get_tree().quit()
