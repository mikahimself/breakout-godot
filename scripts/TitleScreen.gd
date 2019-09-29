extends Node2D

var side_buffer = 40
var top_buffer = 128

var brick_scaled_w = 16
var brick_scaled_h = 8
var brick_w = 16
var brick_h = 8

var ts_label_main
var ts_label_sub

var tween
var tween_start = 1
var tween_end = 0.1

signal title_ready

var brick_scene = load("res://Scenes/brick.tscn")
var level

func _ready():
	level = $leveldata.title
	create_level(0)
	setup_items()

func create_level(level_no):
	for i in range(0, level.size()):
		for j in range(0, level[i].size()):
			if level[i][j] > 0:
				var brick = brick_scene.instance()
				brick.scale = Vector2(1, 1)
				brick.position = Vector2(side_buffer + brick_scaled_w * j, top_buffer + brick_scaled_h * i)
				# The brick image contains several different brick styles.
				# Set the region_rect to pick one based on the current array number
				brick.get_child(1).region_rect = Rect2(brick_w * level[i][j] - 16, 0, brick_w, brick_h)
				# Add the brick to the scene to make it visible
				get_node("brick_container").call_deferred("add_child", brick)
	
	$FadeIn.fade_in(1)
	emit_signal("title_ready")

func setup_items():
	tween = $label_tween
	ts_label_main = $gamescreen_label.get_node("label_maintext")
	ts_label_sub = $gamescreen_label.get_node("label_subtext")
	ts_label_sub.set_text("Press Space to Start")
	
	tween.interpolate_property($gamescreen_label, "modulate", Color(1,1,1,tween_start), Color(1,1,1,tween_end), 1.25, Tween.TRANS_LINEAR, Tween.EASE_OUT_IN)
	tween.connect("tween_completed", self, "_on_tween_completed")
	tween.start()

func _process(delta):
	get_controls()
	
func get_controls():
	if (Input.is_key_pressed(KEY_SPACE)):
		$FadeIn.fade_out(1)

func _on_new_game_button_pressed():
	$FadeIn.show()
	$FadeIn.fade_out(1)

func _on_tween_completed(object, key):
	var tmp = tween_start
	tween_start = tween_end
	tween_end = tmp
	
	tween.interpolate_property($gamescreen_label, "modulate", Color(1,1,1,tween_start), Color(1,1,1,tween_end), 1.25, Tween.TRANS_LINEAR, Tween.EASE_OUT_IN)
	tween.start()

func _on_FadeIn_fade_finished(anim_name):
	if (anim_name == "Fade_Out"):
		get_node("brick_container").queue_free()
		get_tree().change_scene("res://scenes/Gamescreen.tscn")
