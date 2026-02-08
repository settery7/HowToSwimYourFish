extends Area2D

@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

func _on_body_entered(body: Node2D) -> void:
	# Use groups! It's safer than checking body.name
	if body.name == "Fish":
		print(body.name)
	if body.has_method("die"): 
		audio_stream_player_2d.play()
		
		# Tell the fish to play its death logic
		body.die()
		
		# Wait for a bit so the player sees the fish die
		await get_tree().create_timer(1.0).timeout
		
		resetscene()

func resetscene():
	SceneTransistion.restartcurrentscene();
