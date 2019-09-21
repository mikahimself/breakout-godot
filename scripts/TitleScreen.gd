extends Node2D

var side_buffer = 40
var top_buffer = 128

var brick_scaled_w = 16
var brick_scaled_h = 8
var brick_w = 16
var brick_h = 8

signal title_ready

var brick_scene = load("res://Scenes/brick.tscn")
var level = [
			[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
			[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
			[0,2,2,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
			[0,2,0,0,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
			[0,2,0,0,2,0,4,4,0,0,4,4,4,0,0,4,0,0,4,0,4],
			[0,2,2,2,0,0,4,0,4,0,4,0,0,0,4,0,4,0,4,0,4],
			[0,2,0,0,2,0,4,0,4,0,4,4,0,0,4,0,4,0,4,4,0],
			[0,2,0,0,2,0,4,4,0,0,4,0,0,0,4,4,4,0,4,0,4],
			[0,2,0,0,2,0,4,0,4,0,4,0,0,0,4,0,4,0,4,0,4],
			[0,2,2,2,0,0,4,0,4,0,4,4,4,0,4,0,4,0,4,0,4],
			[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
			[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
			[0,0,0,0,0,0,4,4,4,0,4,0,4,0,4,4,4,0,0,0,0],
			[0,0,0,0,0,0,4,0,4,0,4,0,4,0,0,4,0,0,0,0,0],
			[0,0,0,0,0,0,4,0,4,0,4,0,4,0,0,4,0,0,0,0,0],
			[0,0,0,0,0,0,4,0,4,0,4,0,4,0,0,4,0,0,0,0,0],
			[0,0,0,0,0,0,4,0,4,0,4,0,4,0,0,4,0,0,0,0,0],
			[0,0,0,0,0,0,4,4,4,0,4,4,4,0,0,4,0,0,0,0,0],
		]

func _ready():
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
	
	emit_signal("title_ready")

func setup_items():
	pass

func _on_new_game_button_pressed():
	$FadeIn.show()
	$FadeIn.fade_out(1)


func _on_FadeIn_fade_finished(anim_name):
	get_node("brick_container").queue_free()
	get_tree().change_scene("res://scenes/Gamescreen.tscn")
