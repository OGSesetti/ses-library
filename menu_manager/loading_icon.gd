extends Sprite2D

var r_speed = 90

func _process(delta):
	rotation_degrees += r_speed * delta
	print(rotation_degrees)
	if rotation_degrees > 360:
		rotation_degrees = wrapf(rotation_degrees, 0, 360)