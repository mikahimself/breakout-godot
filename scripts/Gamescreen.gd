extends Node2D

var side_buffer = 24
var top_buffer = 88

var brick_scaled_w = 32
var brick_scaled_h = 16
var brick_w = 16
var brick_h = 8
var brick_scores = [0, 10, 15, 20, 25, 30, 35]
var brick_count = 0 setget set_brick_count, get_brick_count

#var ball
#var paddle


var brick_scene = preload("res://Scenes/brick.tscn")
var level = [
			[0,1,1,1,1,1,1,1,1,1,1,1,0],
			[0,2,2,2,2,2,2,2,2,2,2,2,0],
			[0,1,1,1,1,1,1,1,1,1,1,1,0],
			[0,2,2,2,2,2,2,2,2,2,2,2,0],
			[0,1,1,1,1,1,1,1,1,1,1,1,0],
			[0,2,2,2,2,2,2,2,2,2,2,2,0],
			[0,1,1,1,1,1,1,1,1,1,1,1,0]
		]

func _ready():
	create_level()
	setup_items()

func create_level():
	for i in range(0, level.size()):
		for j in range(0, level[i].size()):
			if level[i][j] > 0:
				var brick = brick_scene.instance()
				brick.set_score(brick_scores[level[i][j]])
				brick.position = Vector2(side_buffer + brick_scaled_w * j, top_buffer + brick_scaled_h * i)
				# The brick image contains several different brick styles.
				# Set the region_rect to pick one based on the current array number
				brick.get_child(0).region_rect = Rect2(brick_w * level[i][j] - 16, 0, brick_w, brick_h)
				# Add the brick to the scene to make it visible
				get_tree().get_root().call_deferred("add_child", brick)
				brick_count += 1

func get_brick_count():
	return brick_count	

func set_brick_count(value):
	brick_count -= value

func setup_items():
	pass
