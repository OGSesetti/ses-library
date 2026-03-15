extends CharacterBody2D
class_name Bullet

@export var parent: Gun
@export var hitbox: HitboxModule
var ray_cast: RayCast2D

var damage: int
var projectile_speed: float

var max_distance:int

func _ready():
	ray_cast = $BulletRayCast
	

func _process(delta:float):
	_bullet_process(delta)
	move_and_collide(velocity)

func _bullet_process(delta):
	if hitbox.on_area_entered():#	Olisko parempi kuunnella signaalia?
		_collision_event()	


	if ray_cast.is_colliding():
		var collision_point
		var origin
		var distance
		var distance_per_tick:float
		origin = ray_cast.global_position
		collision_point = ray_cast.get_collision_point()
		distance = origin.distance_to(collision_point)
		distance_per_tick = projectile_speed * delta

		if distance <= distance_per_tick:
			projectile_speed = distance * delta
	velocity = Vector2(0, -projectile_speed).rotated(global_rotation) * delta

func _collision_event():
	queue_free()


