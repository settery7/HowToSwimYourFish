extends RigidBody2D
class_name Feed

@export var fall_speed: float = 100.0
@export var despawn_y: float = 290.0
@export var despawn_delay: float = 2.0

var reached_limit := false

func _ready():
	add_to_group("feeds")  # Make sure this matches CurrentBox check!
	freeze = false
	sleeping = false
	can_sleep = false
	
	gravity_scale = 0.0
	linear_velocity.y = fall_speed
	
	# Disable damping so nothing slows it down
	linear_damp = 0.0
	angular_damp = 0.0

func _physics_process(delta):
	# FORCE constant falling - override everything
	linear_velocity.y = fall_speed
	
	# Debug: print if feed stops moving
	if absf(linear_velocity.y) < 10:
		print("Feed stuck! Velocity: ", linear_velocity, " Position: ", position)
	
	# Check if reached despawn point
	if not reached_limit and position.y >= despawn_y:
		reached_limit = true
		start_despawn_timer()

func start_despawn_timer():
	await get_tree().create_timer(despawn_delay).timeout
	queue_free()
