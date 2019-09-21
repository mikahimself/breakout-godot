extends ColorRect

signal fade_finished(anim_name)

func fade_out(speed):
	$AnimationPlayer.play("Fade_Out", -1, speed, false)

func fade_in(speed):
	$AnimationPlayer.play("Fade_In", -1, speed, false)

func _on_AnimationPlayer_animation_finished(anim_name):
	emit_signal("fade_finished", anim_name)