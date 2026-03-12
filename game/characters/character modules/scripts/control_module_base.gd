extends CharacterModule
class_name ControlModule

signal action_input(int)


func get_movement_input():
	pass

func attack():
	action_input.emit(GameEnums.ActionInputs.ATTACK)

func reload():
	action_input.emit(GameEnums.ActionInputs.RELOAD)
	
func dodge():
	action_input.emit(GameEnums.ActionInputs.DODGE)