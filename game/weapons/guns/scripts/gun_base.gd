extends Weapon
class_name Gun

#@export var parent: HandsModule
@export var parent: CharacterBody2D

@export var input_source: ControlModule

@export var ammo_capacity: int
@export var rate_of_fire: float# or int I don't fucking know
@export var reload_time: float

#	Stats for the bullet:
@export var damage: float = 1# tai int emt
@export var projectile_speed: float = 200
@export var max_distance:int = 6000

var bullet_spawn_point: Node2D
var current_ammo: int

#var bullet = load(Game.projectile_bullet)
var bullet = preload("res://game/weapons/bullets/bullet.tscn")

var ready_to_fire: bool = true

func _ready():
	bullet_spawn_point = $%BulletSpawnPoint
	if input_source:
		input_source.action_input.connect(_on_action_input)
	current_ammo = ammo_capacity
	print(current_ammo)


func _on_action_input(just_pressed, _pressed):
	match just_pressed:
		GameEnums.ActionInput.ATTACK:
			attack()
		GameEnums.ActionInput.RELOAD:
			reload()
		_:
			pass


func attack():
	if current_ammo != 0 and ready_to_fire == true:
		shoot()
		current_ammo -= 1
	elif ready_to_fire == true:
		click_click()
	else:
		pass


func reload():
	if current_ammo >= ammo_capacity:
		return
	ready_to_fire = false
	print("Reloading...")
	await Ses.wait(reload_time)
	current_ammo = ammo_capacity
	print("...done!")
	ready_to_fire = true


func shoot():
	print("pew")
	construct_bullet()

func click_click():
	print("click")
	

func construct_bullet():
	var new_bullet = bullet.instantiate()
	new_bullet.projectile_speed = projectile_speed
	new_bullet.damage = damage
	new_bullet.max_distance = max_distance
	new_bullet.z_index = parent.z_index - 1
	
	get_tree().current_scene.add_child(new_bullet)# Is it okay for this to be a child?
	new_bullet.global_position = bullet_spawn_point.get_global_position()
	new_bullet.global_rotation = bullet_spawn_point.get_global_rotation()

#	Ota selvää Z indeksistä sit kun siitä tulee eventually ongelma että luoti spawnaa aseen yläpuolelle
