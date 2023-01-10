extends Base_minigame
class_name Bullet_hell

enum Patterns {
	P1,
	P2,
	P3
}

var _current_pattern = Patterns.P1

const P1_ROT_SPEED: float = 100.0
const P1_SPAWN_POINT: int = 5
const P1_RADIUS: float = 5.0

const P2_ROT_SPEED: float = 200.0
const P2_SPAWN_POINT: int = 10
const P2_RADIUS: float = 18.0

onready var Bullet1: PackedScene = preload("res://src/mob/projectiles/bullet1.tscn")
onready var Bullet2: PackedScene = preload("res://src/mob/projectiles/bullet2.tscn")

onready var rotater: Node2D = $BH_enemy/rotater
onready var rotater2: Node2D = $BH_enemy/rotater2

onready var player: BH_player = $BH_player

func _ready():
	p2_init()

func _process(delta: float):
	match _current_pattern:
		Patterns.P1:
			p1_loop(delta)
		Patterns.P2:
			p2_loop(delta)

func spawn_bullet1(pos: Vector2, rot: float):
	var bullet: Node2D = Bullet1.instance()
	bullet.position = pos
	bullet.rotation = rot
	$projectiles.add_child(bullet)

func spawn_bullet2(pos: Vector2, target: Node2D):
	var bullet: Node2D = Bullet2.instance()
	bullet.position = pos
	bullet.target = target
	$projectiles.add_child(bullet)

var p2_index: int = 0
func p2_init():
	p2_index = 0
	_current_pattern = Patterns.P2
	var step = 2 * PI / P2_SPAWN_POINT
	
	for i in range(P2_SPAWN_POINT):
		var spawn_point = Node2D.new()
		var pos = Vector2(P2_RADIUS, 0).rotated(step * i)
		spawn_point.position = pos
		spawn_point.rotation = pos.angle()
		rotater.add_child(spawn_point)
	
	for i in range(P1_SPAWN_POINT):
		var spawn_point = Node2D.new()
		var pos = Vector2(P1_RADIUS, 0).rotated(step * i)
		spawn_point.position = pos
		spawn_point.rotation = pos.angle()
		rotater2.add_child(spawn_point)
	
	$shoot_timer.start(0.1)

func p2_bullets():
	var s: Node2D = rotater.get_child(p2_index)
	spawn_bullet2(s.global_position, player)
	for s2 in rotater2.get_children():
		spawn_bullet1(s2.global_position, s2.global_rotation)
	if p2_index == P2_SPAWN_POINT - 1:
		p2_index = 0
	else:
		p2_index += 1

func p2_loop(delta: float):
	rotater2.rotation_degrees = fmod(rotater2.rotation_degrees + P2_ROT_SPEED * delta, 360)

func p2_fini():
	for s in rotater.get_children():
		rotater.remove_child(s)

func p1_init():
	_current_pattern = Patterns.P1
	var step = 2 * PI / P1_SPAWN_POINT
	
	for i in range(P1_SPAWN_POINT):
		var spawn_point = Node2D.new()
		var pos = Vector2(P1_RADIUS, 0).rotated(step * i)
		spawn_point.position = pos
		spawn_point.rotation = pos.angle()
		rotater.add_child(spawn_point)
	$shoot_timer.start(0.2)

func p1_bullets():
	for s in rotater.get_children():
		spawn_bullet1(s.global_position, s.global_rotation)

func p1_loop(delta: float):
	rotater.rotation_degrees = fmod(rotater.rotation_degrees + P1_ROT_SPEED * delta, 360)

func p1_fini():
	for s in rotater.get_children():
		rotater.remove_child(s)

func _on_shoot_timer_timeout():
	match _current_pattern:
		Patterns.P1:
			$shoot_timer.start(0.1)
			p1_bullets()
		Patterns.P2:
			$shoot_timer.start(0.2)
			p2_bullets()
