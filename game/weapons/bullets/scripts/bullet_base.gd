extends CharacterBody2D
class_name Bullet

@export var parent: Gun
@export var hitbox: HitboxModule
var ray_cast: RayCast2D

var damage: int
var projectile_speed: float

var max_distance: int

var distance_traveled:= 0.0
var last_position:= Vector2.ZERO

func _ready():
	ray_cast = $BulletRayCast
	hitbox.connect("area_entered", on_collision)

func _process(delta:float):
	_bullet_process(delta)
	move_and_collide(velocity*delta)

func _bullet_process(delta):
#	if hitbox.on_area_entered(collider):#	Olisko parempi kuunnella signaalia?
#		_collision_event()

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
	#velocity = Vector2(0, -projectile_speed).rotated(global_rotation)
	velocity = Vector2.RIGHT.rotated(global_rotation + deg_to_rad(90)) * projectile_speed
	measure_distance()

func on_collision(_collider):
	print("Collision!")
	queue_free()


func measure_distance():
	var frame_distance = global_position.distance_to(last_position)
	distance_traveled += frame_distance
	last_position = global_position

	if distance_traveled > max_distance:
#		print("Max distance reached")
		queue_free()
