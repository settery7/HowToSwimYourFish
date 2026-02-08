extends Area2D

# Exporting the path makes it easy to pick the next level in the Inspector
@export var next_scene: PackedScene 

func _on_body_entered(body: Node2D) -> void:
	# Check if the object entering is the Fish
	# You can check by name, or better yet, by Class/Group
	if body.name == "Fish":
		clear_stage()

func clear_stage():
	print("Stage Cleared!")
	# Transition to the next level
	if next_scene:
		get_tree().change_scene_to_packed(next_scene)
	else:
		# Fallback or restart if no scene is assigned
		get_tree().reload_current_scene()
