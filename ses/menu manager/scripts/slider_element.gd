extends Control

var setting_id = "undefined"
var var_type = "undefined"	#prob not needed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_slider_value_changed(value:float) -> void:
	var data = [setting_id, var_type, value]
	SignalManager.send_command("settings", "set", data)
