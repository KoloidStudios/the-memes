extends KinematicBody2D
class_name Base_mob

const GRAVITY: float = 20.0

export var health: int = 100
var _hit_stop: bool = false

func _ready() -> void:
	print("Base_mob instance created")
	pass

# Function specific variables
var motion: Vector2 = Vector2.ZERO # Basic motion
var snap:   Vector2 = Vector2.ZERO # Snap to moving platform
func _physics_process(delta) -> void:
	# Adds gravity
	motion.y += GRAVITY
	
	# Apply motion to body
	motion = move_and_slide_with_snap(motion, snap, Vector2.UP, true, 4, 0.785398, false)
	
	if (is_on_floor() and health == 0):
		die()

# Function specific variables
var _is_jumped: bool = false
func jump(power: float) -> void:
	if is_on_floor(): 
		motion.y -= power
		_is_jumped = true

func hit() ->void:
	pass

func die() -> void:
	pass

func spawn() -> void:
	pass
