extends Base_minigame
class_name Bullet_hell

enum Patterns {
	P1,
	P2,
	P3
}

var trial: int = 3

var _current_pattern = Patterns.P1

const P1_ROT_SPEED: float = 100.0
const P1_SPAWN_POINT: int = 5
const P1_RADIUS: float = 5.0

const P2_ROT_SPEED: float = 200.0
const P2_SPAWN_POINT: int = 10
const P2_RADIUS: float = 18.0

const P3_ROT_SPEED: float = 80.0
const P3_SPAWN_POINT: int = 12
const P3_RADIUS: float = 24.0

onready var Bullet1: PackedScene = preload("res://src/mob/projectiles/bullet1.tscn")
onready var Bullet2: PackedScene = preload("res://src/mob/projectiles/bullet2.tscn")

onready var rotater: Node2D = $BH_enemy/rotater
onready var rotater2: Node2D = $BH_enemy/rotater2

onready var player: BH_player = $BH_player

onready var timeout: Timer = $timeout
onready var time_label: Label = $sticky_layer/time_label

var _death_cd: bool = false
func start():
	_win = false
	_started = true
	player.live()
	p1_init()
	timeout.start(15.0)

func _ready():
	player._dead = true
	$animation.play("open")
	yield($animation, "animation_finished")
	enter_dialog(2)
	yield(dialog, "finished")
	start()

func _process(delta: float):
	if (!_started): return
	
	time_label.text = "0:" + String(ceil(timeout.time_left))
	
	if (_death_cd): return
	match _current_pattern:
		Patterns.P1:
			p1_loop(delta)
		Patterns.P2:
			p2_loop(delta)
		Patterns.P3:
			p3_loop(delta)

func spawn_bullet1(pos: Vector2, rot: float):
	var bullet: Node2D = Bullet1.instance()
	bullet.position = pos
	bullet.rotation = rot
	$projectiles.add_child(bullet)
	$shoot.play()
	
func spawn_bullet2_2(pos: Vector2, rot: float):
	var bullet: Node2D = Bullet2.instance()
	bullet.position = pos
	bullet.rotation = rot
	$projectiles.add_child(bullet)
	$shoot.play()

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
	$shoot_timer.start(0.2)
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
	$shoot_timer.start(0.1)
	for s in rotater.get_children():
		spawn_bullet1(s.global_position, s.global_rotation)

func p1_loop(delta: float):
	rotater.rotation_degrees = fmod(rotater.rotation_degrees + P1_ROT_SPEED * delta, 360)

func p1_fini():
	for s in rotater.get_children():
		rotater.remove_child(s)

func p3_init():
	_current_pattern = Patterns.P3
	var step = 2 * PI / P3_SPAWN_POINT
	
	for i in range(P3_SPAWN_POINT):
		var spawn_point = Node2D.new()
		var pos = Vector2(P3_RADIUS, 0).rotated(step * i)
		spawn_point.position = pos
		spawn_point.rotation = pos.angle()
		rotater.add_child(spawn_point)
	$shoot_timer.start(1.0)
	$explode.play(0)
	$transparent/tween.interpolate_property($transparent, "color:a", 0.0, 0.2, 1.0, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$transparent/tween.start()

var _time: float = 0.0
var _sine: float = 0.0

func p3_bullets():
	$shoot_timer.start(0.1)
	for s in rotater.get_children():
		if _sine >= 0:
			spawn_bullet1(s.global_position, s.global_rotation)
		else:
			spawn_bullet2_2(s.global_position, s.global_rotation)
		
func p3_loop(delta: float):
	rotater.rotation_degrees = _sine * 360
	_time += delta
	_sine = sin(_time * P3_ROT_SPEED)

func p3_fini():
	for s in rotater.get_children():
		rotater.remove_child(s)
	$transparent/tween.interpolate_property($transparent, "color:a", 0.2, 0.0, 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$transparent/tween.start()

func _on_shoot_timer_timeout():
	if (_death_cd): return
	match _current_pattern:
		Patterns.P1:
			p1_bullets()
		Patterns.P2:
			p2_bullets()
		Patterns.P3:
			p3_bullets()

func _on_timeout_timeout():
	_started = false
	time_label.text = "0:0"
	$shoot_timer.stop()
	yield(get_tree().create_timer(2.0), "timeout")
	match _current_pattern:
		Patterns.P1:
			p1_fini()
			p2_init()
		Patterns.P2:
			p2_fini()
			p3_init()
		Patterns.P3:
			p3_fini()
			player._dead = true
			_win = true
			Global.bullet_hell_score = trial
			enter_dialog(4)
			return
	timeout.start(15.0)
	_started = true

func _restart():
	_restart = true
	trial = 3
	$sticky_layer/health/label.text = ": x" + String(trial)
	$tween.interpolate_property(player, "position", player.position, Vector2(240, 250), 0.8, Tween.TRANS_CIRC, Tween.EASE_OUT)
	$tween.interpolate_property(player, "modulate:a", 0.0, 1.0, 0.5, Tween.TRANS_CIRC, Tween.EASE_OUT)
	$tween.start()
	yield($tween, "tween_all_completed")
	yield(get_tree().create_timer(2), "timeout")
	start()

func _on_BH_player_dead():
	trial -= 1
	print(trial)
	$sticky_layer/health/label.text = ": x" + String(trial)
	shake(10, 20)
	$explode.play(0.33)
	player.modulate.a = 0.0
	for s in $projectiles.get_children():
		s.queue_free()
	if (trial == 0):
		$shoot_timer.stop()
		$timeout.stop()
		_started = false
		match _current_pattern:
			Patterns.P1:
				p1_fini()
			Patterns.P2:
				p2_fini()
			Patterns.P3:
				p3_fini()
		enter_confirm("retry", funcref(self, "_restart"))
		yield(_active_confirm_menu, "confirmation_finished")
		if (!_restart):
			Global.goto_scene("res://src/world/event_anjimeh.tscn", Vector2(472, 223), false)
		else:
			_restart = false
		return
	_death_cd = true
	$death_cd.start(2.0)
	$tween.interpolate_property(player, "position", player.position, Vector2(240, 250), 0.8, Tween.TRANS_CIRC, Tween.EASE_OUT)
	$tween.interpolate_property(player, "modulate:a", 0.0, 1.0, 0.5, Tween.TRANS_CIRC, Tween.EASE_OUT)
	$tween.start()
	yield($tween, "tween_all_completed")
	player.live()
	
func _on_death_cd_timeout():
	_death_cd = false
	
func _on_dialog_player_finished():
	if (_win):
		Global.goto_scene("res://src/world/event_anjimeh.tscn", Vector2(472, 223), false)
