extends Node2D

# Text constants
var txt_game_over_main = "GAME OVER"
var txt_game_over_sub = "Press Space to Continue"
var txt_lvl_finished_main = "LEVEL FINISHED"
var txt_get_ready_main = "GET READY"
var txt_get_ready_sub = "Press Space to Start"
var txt_congrats_main = "CONGRATULATIONS"
var txt_congrats_sub = "You Beat the Final Level!\nPress Space to Continue"
var txt_none = ""

var side_buffer = 40
var top_buffer = 128

var brick_scaled_w = 32
var brick_scaled_h = 16
var brick_w = 16
var brick_h = 8
var brick_scores = [0, 10, 15, 20, 25, 30, 35]
var brick_count = 0 setget set_brick_count, get_brick_count

signal level_ready

var brick_scene = load("res://scenes/brick.tscn")
var level
var levels

var gs_label_main
var gs_label_sub

var is_level_finished
var is_game_over
var label_tween

func _ready():
	label_tween = $textboxes.get_node("label_tween")
	setup_items()
	create_level()

func create_level():
	is_level_finished = false
	is_game_over = false
	brick_count = 0
	for i in range(0, level.size()):
		for j in range(0, level[i].size()):
			if level[i][j] > 0:
				var brick = brick_scene.instance()
				brick.set_score(brick_scores[level[i][j]])
				brick.position = Vector2(side_buffer + brick_scaled_w * j, top_buffer + brick_scaled_h * i)
				# The brick image contains several different brick styles.
				# Set the region_rect to pick one based on the current array number
				brick.get_child(1).region_rect = Rect2(brick_w * level[i][j] - 16, 0, brick_w, brick_h)
				# Add the brick to the scene to make it visible
				get_node("brick_container").call_deferred("add_child", brick)
				brick_count += 1
	show_screen()

func get_brick_count():
	return brick_count	

func set_brick_count(value):
	brick_count -= value

func setup_items():
	levels = $leveldata.levels
	level = levels[$game_controller.level]
	gs_label_main = $gamescreen_label.get_node("label_maintext")
	gs_label_sub = $gamescreen_label.get_node("label_subtext")

func _on_game_controller_level_finished():
	is_level_finished = true
	show_label(txt_lvl_finished_main, txt_none)
	for brick in get_node("brick_container").get_children():
		brick.queue_free()
	
func _on_game_controller_level_change():
	hide_label()
	fade_screen()
	yield($FadeIn.get_node("AnimationPlayer"), "animation_finished")
	setup_items()
	create_level()

func _on_FadeIn_fade_finished(anim_name):
	if anim_name == "Fade_In":
		emit_signal("level_ready", brick_count)
		show_label(txt_get_ready_main, txt_get_ready_sub)
	if is_game_over:
		get_tree().change_scene("res://scenes/TitleScreen.tscn")

func _on_paddle_ball_shot():
	hide_label()

func show_label(main_text, sub_text):
	gs_label_main.set_text(main_text)
	gs_label_sub.set_text(sub_text)
	label_tween.interpolate_property($gamescreen_label, "modulate", Color(1,1,1,0), Color(1,1,1,1), 0.25, Tween.TRANS_LINEAR, Tween.EASE_IN)
	label_tween.start()

func hide_label():
	label_tween.interpolate_property($gamescreen_label, "modulate", Color(1,1,1,1), Color(1,1,1,0), 0.25, Tween.TRANS_LINEAR, Tween.EASE_IN)
	label_tween.start()

func fade_screen():
	$FadeIn.show()
	$FadeIn.fade_out(1)

func show_screen():
	$FadeIn.show()
	$FadeIn.fade_in(1)

func _on_game_controller_game_over():
	show_label(txt_game_over_main, txt_game_over_sub)
	is_game_over = true

func _on_game_over_area_body_entered(body):
	# Don't show get ready label every time 
	# the ball goes into the gutter.
	show_label(txt_none, txt_none)

func _on_paddle_trigger_scene_change():
	hide_label()
	fade_screen()

func _on_game_controller_game_finished():
	show_label(txt_congrats_main, txt_congrats_sub)
	is_game_over = true
