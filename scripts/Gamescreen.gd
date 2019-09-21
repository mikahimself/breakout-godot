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

var brick_scene = load("res://Scenes/brick.tscn")
var level
var levels

var gs_label_main
var gs_label_sub

func _ready():
	setup_items()
	create_level()

func create_level():
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
	print("current level: ", level)

func _on_game_controller_level_finished():
	show_label(txt_lvl_finished_main, txt_none)
	for brick in get_node("brick_container").get_children():
		brick.queue_free()
	
func _on_game_controller_level_change():
	hide_label()
	fade_screen()
	setup_items()
	create_level()

func _on_FadeIn_fade_finished(anim_name):
	print("fade finished ", anim_name)
	if anim_name == "Fade_In":
		emit_signal("level_ready", brick_count)
		show_label(txt_get_ready_main, txt_get_ready_sub)

func _on_paddle_ball_shot():
	hide_label()

func show_label(main_text, sub_text):
	gs_label_main.set_text(main_text)
	gs_label_sub.set_text(sub_text)
	$gamescreen_label.show()

func hide_label():
	gs_label_main.set_text(txt_none)
	gs_label_sub.set_text(txt_none)
	$gamescreen_label.hide()

func fade_screen():
	$FadeIn.show()
	$FadeIn.fade_out(0.5)

func show_screen():
	$FadeIn.show()
	$FadeIn.fade_in(0.5)