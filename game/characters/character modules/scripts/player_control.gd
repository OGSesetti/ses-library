extends ControlModule
class_name PlayerControl

@export var enable_wasd: bool = true

var movement_input : Vector2

func _process(_delta):#	Tarvitsiko is_action_pressed processin?
	get_movement_input()
	if Input.is_action_pressed("attack"):
		attack()
	if Input.is_action_pressed("reload"):
		reload()
	if Input.is_action_pressed("dodge"):
		dodge()


func get_movement_input():# -> Vector2:
	if enable_wasd == true:
		movement_input.x = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
		movement_input.y = int(Input.is_action_pressed("move_down")) - int(Input.is_action_pressed("move_up"))