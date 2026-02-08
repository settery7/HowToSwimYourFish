extends Node2D

@export var spawn_scene: PackedScene
@export var fixed_y: float = -290.0

func _input(event):
	if event is InputEventMouseButton \
	and event.pressed \
	and event.button_index == MOUSE_BUTTON_LEFT:
		
		spawn_at_mouse_x()

func spawn_at_mouse_x():
	var instance = spawn_scene.instantiate()
	
	var mouse_x = get_local_mouse_position().x
	instance.position = Vector2(mouse_x, fixed_y)
	add_child(instance)
