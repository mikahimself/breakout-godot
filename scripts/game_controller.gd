extends Node2D

# ball states 
# on paddle = 0
# in play 1
# out of bounds 2

var out_of_bounds_timer
var ball_state
var no_of_balls_in_play
var ball
var gamescreen

# Numbers
var score
var lives
var level
var brick_count

# Labels
var label_score
var label_lives
var label_level



func _ready():
	ball = load("res://Scenes/ball.tscn")
	
	no_of_balls_in_play = 0
	ball_state = 0
	score = 0
	lives = 3
	level = 1
	gamescreen = get_parent()
	setup_timers()
	init_ball()
	setup_labels()
	

func setup_timers():
	out_of_bounds_timer = Timer.new()
	out_of_bounds_timer.set_one_shot(true)
	out_of_bounds_timer.set_wait_time(0.75)
	out_of_bounds_timer.connect("timeout", self, "_on_out_of_bounds_timeout")
	add_child(out_of_bounds_timer)

func setup_labels():
	label_score = get_parent().get_node("textboxes").get_node("label_score")
	label_level = get_parent().get_node("textboxes").get_node("label_level")
	label_lives = get_parent().get_node("textboxes").get_node("label_lives")

func _on_paddle_ball_shot():
	ball_state = 1
	no_of_balls_in_play += 1

func _on_game_over_area_body_entered(body):
	no_of_balls_in_play -= 1

	if no_of_balls_in_play == 0:
		ball_state = 2
		out_of_bounds_timer.start()

func _on_out_of_bounds_timeout():
	ball_state = 0
	if _update_lives():
		init_ball()

func _update_score(add_score):
	score += add_score
	_update_brick_count()
	label_score.set_text(str(score))

func _update_lives():
	lives -= 1
	if lives < 0:
		print("game over")
		return false
	else:
		set_lives_string()
		label_lives.set_text(set_lives_string())
		return true

func _update_brick_count():
	brick_count -= 1
	print("Bricks left: ", brick_count)
	if brick_count <= 0:
		print("level finished")

func set_lives_string():
	var lives_string = str(lives)
	if len(lives_string) > 1:
		return lives_string
	else:
		return "0" + lives_string


func init_ball():
	var ball_node = ball.instance()
	ball_node.connect("got_brick", self, "_update_score")
	get_parent().call_deferred("add_child", ball_node)
	

func _on_Gamescreen_level_ready(bricks):
	brick_count = bricks
	print(brick_count)
	
