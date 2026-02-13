class_name Setting
extends Resource

@export var id: String
@export var display_name: String = "MISSING DISPLAY NAME"
enum categories {
	GAME,
	VIDEO,
	SOUND,
	CONTROLS
}

@export var category: categories

#@export var category: int #								0 = game, 1 = video, 2 = sound, 3 = controls


