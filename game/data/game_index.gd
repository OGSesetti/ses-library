extends Node
var Level = GameEnums.Level
var Projectile = GameEnums.Projectile
#	var Weapon = GameEnums.Weapon

var BULLET := "res://game/weapons/bullets/bullet.tscn"

var level: Dictionary[int, String] = {
	Level.LEVEL_1: "res://game/scenes/levels/level1.tscn",
	Level.LEVEL_2: "res://game/scenes/levels/level2.tscn",
	Level.TEST_MENU: "res://ses/menu manager/scenes/independent menus/testmenu.tscn",
	
}

var projectile: Dictionary[int, String] = {
	Projectile.BULLET: "res://game/weapons/bullets/bullet.tscn"
}
