extends Node2D
class_name Feed

@export var fall_speed: float = 200.0
@export var despawn_y: float = 700.0
@export var despawn_delay: float = 2.0

var reached_limit := false

func _process(delta):
	if not reached_limit:
		position.y += fall_speed * delta

		if position.y >= despawn_y:
			reached_limit = true
			start_despawn_timer()

func start_despawn_timer():
	await get_tree().create_timer(despawn_delay).timeout
	queue_free()

func _ready():
	add_to_group("feeds")
