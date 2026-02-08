extends CharacterBody2D

const SPEED := 100.0
const EAT_DISTANCE := 40.0 # Increased slightly for buffer

@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

enum FishState { SWIM, TURN, EAT, DEAD }
var state: FishState = FishState.SWIM

enum Facing { LEFT, RIGHT }
var facing: Facing = Facing.RIGHT
var current_feed: Node2D = null

func _ready() -> void:
	# Essential: Connect signal to know when "Turn" or "Eat" finishes
	anim.animation_finished.connect(_on_animation_finished)

func _physics_process(_delta: float) -> void:
	if state == FishState.DEAD:
		return

	# 1. Dynamic Retargeting
	# Update target every frame (or use a Timer for performance)
	find_closest_feed()

	if current_feed == null:
		velocity = velocity.move_toward(Vector2.ZERO, 5.0) 
		move_and_slide()
		play_swim()
		return

	# 2. Pathfinding Logic
	nav_agent.target_position = current_feed.global_position
	var next_path_pos := nav_agent.get_next_path_position()
	var dir := global_position.direction_to(next_path_pos)

	# 3. Direction & Turn Trigger
	var new_facing := Facing.RIGHT if dir.x >= 0 else Facing.LEFT
	if new_facing != facing and state != FishState.TURN:
		start_turn(new_facing)

	# 4. Movement
	velocity = dir * SPEED
	move_and_slide()

	# 5. Animation Priority
	if state == FishState.TURN or state == FishState.EAT:
		pass 
	else:
		play_swim()

	# 6. Interaction Trigger
	if global_position.distance_to(current_feed.global_position) <= EAT_DISTANCE:
		if state != FishState.EAT:
			start_eat()
					
func _on_animation_finished() -> void:
	if state == FishState.TURN or state == FishState.EAT:
		if state == FishState.EAT and is_instance_valid(current_feed):
			reach_feed()
		
		state = FishState.SWIM
		play_swim()

func start_turn(new_facing: Facing) -> void:
	state = FishState.TURN
	facing = new_facing
	var anim_name = "turn_l2r" if facing == Facing.RIGHT else "turn_r2l"
	anim.play(anim_name)

func start_eat() -> void:
	state = FishState.EAT
	
	# 1. Play the animation
	anim.play("eat_right" if facing == Facing.RIGHT else "eat_left")
	
	# 2. Immediately remove the food so it can't be eaten again
	if is_instance_valid(current_feed):
		current_feed.queue_free()
		current_feed = null # Clear the reference immediately
	
func play_swim() -> void:
	var anim_name = "swim_right" if facing == Facing.RIGHT else "swim_left"
	if anim.animation != anim_name:
		anim.play(anim_name)

# --- Helper Functions ---

func find_closest_feed() -> void:
	var feeds := get_tree().get_nodes_in_group("feeds")
	
	if feeds.is_empty():
		current_feed = null
		return

	var closest_feed: Node2D = null
	var closest_dist := INF

	for feed in feeds:
		if is_instance_valid(feed):
			var dist := global_position.distance_squared_to(feed.global_position)
			if dist < closest_dist:
				closest_dist = dist
				closest_feed = feed

	current_feed = closest_feed
	
func reach_feed() -> void:
	if current_feed:
		current_feed.queue_free()
		current_feed = null
