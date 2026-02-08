extends CanvasLayer

func change_scene(target: PackedScene) -> void:
	$AnimationPlayer.play('dissolve')
	await $AnimationPlayer.animation_finished
	get_tree().change_scene_to_packed(target)
	$AnimationPlayer.play_backwards('dissolve')

func stage_clear(target: PackedScene) -> void:
	$AnimationPlayer.play('StageClear')
	await $AnimationPlayer.animation_finished
	$AnimationPlayer.play_backwards('StageClear')
	await $AnimationPlayer.animation_finished
	$AnimationPlayer.play('dissolve')
	await $AnimationPlayer.animation_finished
	get_tree().change_scene_to_packed(target)
	$AnimationPlayer.play_backwards('dissolve')
	
func restartcurrentscene():
	$AnimationPlayer.play('dissolve')
	await $AnimationPlayer.animation_finished
	get_tree().reload_current_scene()
	$AnimationPlayer.play_backwards('dissolve')
