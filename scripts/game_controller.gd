extends Node2D

# ball states 
# on paddle = 0
# in play 1
# out of bounds 2

var out_of_bounds_timer

var ball_state

var no_of_balls_in_play

var ball

func _ready():
	ball = load("res://Scenes/ball.tscn")
	no_of_balls_in_play = 0
	ball_state = 0
	setup_timers()
	init_ball()
	

func setup_timers():
	out_of_bounds_timer = Timer.new()
	out_of_bounds_timer.set_one_shot(true)
	out_of_bounds_timer.set_wait_time(0.75)
	out_of_bounds_timer.connect("timeout", self, "_on_out_of_bounds_timeout")
	add_child(out_of_bounds_timer)

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
	init_ball()

func init_ball():
	var ball_node = ball.instance()
	get_parent().call_deferred("add_child", ball_node)