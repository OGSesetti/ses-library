class_name SettingsResource
extends Resource

#	This system is designed to work with MenuManager's settings list elements, but can also be used independently

#	Category determines the page the setting will be on
#	Categories consist of: game, video, sound, controls

#	Type determines what kind of element is used to adjust the setting
#	Element "types" consist of: checkbox, dropdown, slider

@export var adjustable_settings = [

#	Game

{"name": "Camera adjusted by cursor", "category": "game", "type": "checkbox", "default": "true", "current": true},


#	Video

{"name": "Fullscreen", "category": "video", "type": "checkbox", "default": true, "current": true},

{"name": "Resolution", "category": "video", "type": "dropdown", "options": ["1920x1080", "2560x1440"], "default": "1920x1080", "current": "1920x1080"},



#	Sound

#the values should be edited in the settings resource with _on_updated() or something like that
{"name": "Master volume", "category": "sound", "type": "slider", "min_value": 0, "max_value": 100, "default": 50, "current": 50},

{"name": "Effects volume", "category": "sound", "type": "slider", "min_value": 0, "max_value": 100, "default": 50, "current": 50},

{"name": "Music volume", "category": "sound", "type": "slider", "min_value": 0, "max_value": 100, "default": 50, "current": 50},


#	Controls

#	Invisible settings?




]

