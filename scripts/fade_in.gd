extends ColorRect

signal fade_finished

func fade_out():
	$AnimationPlayer.play("Fade_Out")

func fade_in():
	$AnimationPlayer.play("Fade_In")

func _on_AnimationPlayer_animation_finished(anim_name):
	emit_signal("fade_finished")