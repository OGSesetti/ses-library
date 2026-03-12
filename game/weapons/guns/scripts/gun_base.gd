extends Weapon
class_name Gun

#@export var parent: HandsModule
@export var parent: CharacterBody2D


@export var ammo_capacity: int
@export var rate_of_fire: float# or int I don't fucking know
@export var reload_speed: float

@export var projectile: Bullet
#	Stats for the bullet:
@export var damage: float = 1# tai int emt
@export var projectile_speed: float = 200
@export var max_distance:int = 6000

var bullet_spawn_point: Node2D
var current_ammo: int = ammo_capacity


func _ready():
	bullet_spawn_point = $%BulletSpawnPoint


func _on_action_input(input):
	match input:
		GameEnums.ActionInputs.ATTACK:
			attack()
		GameEnums.ActionInputs.RELOAD:
			reload()
		_:
			pass

func attack():
	if current_ammo != 0:
		shoot()
		current_ammo -= 1
	else:
		click_click()
		reload()


func reload():
	pass


func shoot():
	print("pew")


func click_click():
	print("click click")
	

func construct_bullet():
	var bullet = projectile.instantiate()
	bullet.projectile_speed = projectile_speed
	bullet.damage = damage
	bullet.max_distance = max_distance
	bullet.global_position = bullet_spawn_point.get_global_position()
	bullet.global_rotation = bullet_spawn_point.get_global_rotation()
	
	bullet_spawn_point.add_child(bullet)# Is it okay for this to be a child?


#	Ota selvää Z indeksistä sit kun siitä tulee eventually ongelma että luoti spawnaa aseen yläpuolelle