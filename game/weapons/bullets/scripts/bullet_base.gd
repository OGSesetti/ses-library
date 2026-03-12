"""
TODO:
	Irrota luoti jotenkin parentista jossa se ei seuraa sitä.



Pseudokooditime:

	Signaali: Osuma

	funktio: ready:
		Ota damage, projectile_speed ja mahdollisesti lifetime aseelta
		Ota sijainti ja rotaatio aseelta
		Spawnaa		*Voi olla että tää kaikki pitää tehdä aseen puolella

	funktio: process:
		Jos luodin hitbox collidee objektin kanssa:
			osumalogiikka(osumakohde)

		Tee raycast, joka tarkistaa onko luodin nykyisen sijainnin ja seuraavan tickin sijainnin välissä estettä
		Jos on:
			Luodin seuraava sijainti onkin raycastin osumakohdan sijainti
		Jos ei:
			Luodin sijainti määräytyy nopeuden ja kulman perusteella kuten normaalisti


	funktio: osumalogiikka(osumakohde):
		*Damaget ja muut tapahtuu vastaanottajan puolella.

		Lähetä signaali(Osuma) *Mahdollisille moduuleille esim. ricochea ja animaatioita varten

		*JOS vastaanottavalla objektilla ei ole aikaa lukea luodin tietoja, tee funktio joka sammuttaa collisiot ja raycastin,
		tekee luodista näkymättömän, asettaa nopeuden nollaan ja odottaa yhden framen. Tälle ei pitäisi olla tarvetta mutta ei tästä
		vitun moottorista ikinä tiiä

		Poista luoti

"""


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
	if hitbox.is_colliding():#	Olisko parempi kuunnella signaalia?
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
