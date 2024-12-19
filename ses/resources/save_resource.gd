class_name SaveResource
extends Resource
@export var name: String
@export var level: int
@export var inventory: Array #tai Dictionary

func _init(p_name = "Jesse", p_level = 1, p_inventory = []):
	name = p_name
	level = p_level
	inventory = p_inventory