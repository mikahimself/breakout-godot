extends Node2D

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

func _ready():
	setup_items()
	create_level()
	#$FadeIn.show()
	#$FadeIn.fade_in()
	

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
	emit_signal("level_ready", brick_count)
	show_screen()

func get_brick_count():
	return brick_count	

func set_brick_count(value):
	brick_count -= value

func setup_items():
	levels = $leveldata.levels
	level = levels[$game_controller.level]
	print("current level: ", level)

func _on_game_controller_level_finished():
	for brick in get_node("brick_container").get_children():
		brick.queue_free()
	setup_items()
	create_level()

func fade_screen():
	$FadeIn.show()
	$FadeIn.fade_out()

func show_screen():
	$FadeIn.show()
	$FadeIn.fade_in()