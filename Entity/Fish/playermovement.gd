extends CharacterBody2D

const SPEED := 300.0

func _physics_process(_delta: float) -> void:
	var input_vector := Vector2(
		Input.get_axis("ui_left", "ui_right"),
		Input.get_axis("ui_up", "ui_down")
	)

	# Prevent faster diagonal movement
	if input_vector.length() > 1:
		input_vector = input_vector.normalized()

	velocity = input_vector * SPEED
	move_and_slide()
