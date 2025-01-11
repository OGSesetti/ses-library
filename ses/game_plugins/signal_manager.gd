extends Node

signal settings_updated()

func emit_custom(s, data = null):
	if data == null:
		emit_signal(s)
	else:	
		emit_signal(s, data)

func update_settings():
	emit_signal("settings_updated")