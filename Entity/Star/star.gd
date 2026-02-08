extends Area2D

# Exporting the path makes it easy to pick the next level in the Inspector
@export var next_scene: PackedScene 
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

func _on_body_entered(body: Node2D) -> void:
	# Check if the object entering is the Fish
	# You can check by name, or better yet, by Class/Group
	if body.name == "Fish":
		audio_stream_player_2d.play()
		clear_stage()

func clear_stage():
	print("Stage Cleared!")
	# Transition to the next level
	if next_scene:
		SceneTransistion.stage_clear(next_scene)
	else:
		# Fallback or restart if no scene is assigned
		get_tree().reload_current_scene()


func _on_button_button_down() -> void:
	SceneTransistion.change_scene(next_scene)
