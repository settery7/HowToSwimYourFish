extends Area2D

@export var current_strength: float = 5000.0  # Increased!
@export var current_direction: Vector2 = Vector2.RIGHT
@export var affects_fish: bool = false

@onready var particles = $GPUParticles2D
var bodies_in_current = []

func _ready():
	
	current_direction = current_direction.normalized()
	setup_particles()
	
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func setup_particles():
	particles.rotation = current_direction.angle()
	
	var material = particles.process_material as ParticleProcessMaterial
	if material:
		material.direction = Vector3(current_direction.x, current_direction.y, 0)

func _physics_process(delta):
	for body in bodies_in_current:
		if body and is_instance_valid(body):
			apply_current_force(body, delta)

func _on_body_entered(body):
	print("DETECTED: ", body.name)
	
	if body.is_in_group("feeds"):
		bodies_in_current.append(body)
		print("✓ FEED ADDED!")
	elif affects_fish and body.is_in_group("fish"):
		bodies_in_current.append(body)
		print("✓ FISH ADDED!")

func _on_body_exited(body):
	bodies_in_current.erase(body)
	print("Body exited: ", body.name)

func apply_current_force(body, delta):
	if body is RigidBody2D:
		# Method 1: Try waking it up first
		body.sleeping = false
		
		# Method 2: Set velocity directly (works on kinematic too)
		body.linear_velocity += current_direction * current_strength * delta
		
		print("Velocity set: ", body.linear_velocity, " Pos: ", body.position)
