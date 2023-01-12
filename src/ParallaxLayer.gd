extends ParallaxLayer

export(float) var speed = -30

func _process(delta):
	motion_offset.x += speed * delta

