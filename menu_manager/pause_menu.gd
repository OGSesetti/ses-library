extends Control

var active: bool = false



func _ready() -> void:
	self.hide()


#	TEMPORARY SOLUTION: REMEMBER TO MOVE ALL KEY INPUTS TO THE INPUT HANDLER
func _process(delta: float) -> void:	#delta turha?
	if Input.is_action_just_pressed("ui_cancel"):
		toggle()

func toggle():
	if active == false:
		get_tree().paused = true
		self.show()
		active = true
	else:
		get_tree().paused = false
		self.hide()
		active = false