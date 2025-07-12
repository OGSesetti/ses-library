class_name SettingsResource
extends Resource

#	This system is designed to work with MenuManager's settings list elements, but can also be used independently

#	Category determines the page the setting will be on
#	Categories consist of: game, video, sound, controls			and accessibility?

#	Element determines what kind of menu element is used to adjust the setting
#	Element "elements" consist of: checkbox, dropdown, slider

@export var adjustable_settings = [

#	Game

{"id": "cfc", "display_name": "Camera adjusted by cursor", "category": "game", "element": "checkbox", "var_type": "bool", "default": true, "current": true},


#	Video

{"id": "fullscreen", "display_name": "Fullscreen", "category": "video", "element": "checkbox", "var_type": "bool", "default": true, "current": true},

{"id": "resolution", "display_name": "Resolution", "category": "video", "element": "dropdown", "var_type": "String", "options": ["1920x1080", "2560x1440"], "default": "1920x1080", "current": "1920x1080"},



#	Sound

#the values should be edited in the settings resource with _on_updated() or something like that
{"id": "vol", "display_name": "Master volume", "category": "sound", "element": "slider", "var_type": "float", "min_value": 0, "max_value": 1, "default": 0.5, "current": 0.3},

{"id": "sfx", "display_name": "Effects volume", "category": "sound", "element": "slider", "var_type": "float", "min_value": 0, "max_value": 1, "default": 0.5, "current": 0.3},

{"id": "music", "display_name": "Music volume", "category": "sound", "element": "slider", "var_type": "float", "min_value": 0, "max_value": 1, "default": 0.5, "current": 0.3},


#	Controls

#	Invisible settings?




]

