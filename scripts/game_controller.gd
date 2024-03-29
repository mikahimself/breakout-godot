extends Node2D

# ball states 
# on paddle = 0
# in play 1
# out of bounds 2
# game over 3

var out_of_bounds_timer
var level_finished_timer
var ball_state
var no_of_balls_in_play
var ball
var gamescreen

# Numbers
var score
var lives
var level
var level_count
var brick_count

# Sounds

var snd_out_of_bounds
var snd_level_finished
var snd_game_finished
var snd_game_over
var snd_wall_hit

# Labels
var label_score
var label_lives
var label_level

# Signals
signal level_finished
signal level_change
signal game_finished
signal game_over


func _ready():
	ball = load("res://scenes/ball_gamescreen.tscn")
	
	no_of_balls_in_play = 0
	ball_state = 0
	score = 0
	lives = 3
	level = 0
	level_count = get_parent().get_node("leveldata").levels.size()
	gamescreen = get_parent()
	load_sounds()
	setup_timers()
	init_ball()
	setup_labels()
	

func setup_timers():
	out_of_bounds_timer = Timer.new()
	out_of_bounds_timer.set_one_shot(true)
	out_of_bounds_timer.set_wait_time(0.75)
	out_of_bounds_timer.connect("timeout", self, "_on_out_of_bounds_timeout")

	level_finished_timer = Timer.new()
	level_finished_timer.set_one_shot(true)
	level_finished_timer.set_wait_time(1.5)
	level_finished_timer.connect("timeout", self, "_on_level_finished_timeout")

	add_child(out_of_bounds_timer)
	add_child(level_finished_timer)

func load_sounds():
	snd_out_of_bounds = load("res://sounds/29_noise.wav")
	snd_level_finished = load("res://sounds/sfx_sounds_powerup2.wav")
	snd_game_finished = load("res://sounds/VictorySmall.wav")
	snd_game_over = load("res://sounds/350985__cabled-mess__lose-c-02.wav")
	snd_wall_hit = load("res://sounds/ping_pong_8bit_plop.ogg")


func setup_labels():
	label_score = get_parent().get_node("textboxes").get_node("label_score")
	label_level = get_parent().get_node("textboxes").get_node("label_level")
	label_lives = get_parent().get_node("textboxes").get_node("label_lives")
	label_score.set_text(str(score))
	label_level.set_text(set_lives_level_string(level + 1))
	label_lives.set_text(set_lives_level_string(lives))

func _on_paddle_ball_shot():
	ball_state = 1
	no_of_balls_in_play += 1

func _on_game_over_area_body_entered(body):
	no_of_balls_in_play -= 1

	if no_of_balls_in_play == 0:
		if (lives -1 < 0):
			$audioplayer.stream = snd_game_over
		else:
			$audioplayer.stream = snd_out_of_bounds
		$audioplayer.play()
		ball_state = 2
		out_of_bounds_timer.start()

func _on_out_of_bounds_timeout():
	ball_state = 0
	if _update_lives():
		init_ball()

func _on_level_finished_timeout():
	emit_signal("level_change")

func _update_score(add_score):
	score += add_score
	_update_brick_count()
	label_score.set_text(str(score))

func _update_lives():
	lives -= 1
	if lives < 0:
		ball_state = 3
		emit_signal("game_over")
		return false
	else:
		label_lives.set_text(set_lives_level_string(lives))
		return true

func _update_brick_count():
	brick_count -= 1
	if brick_count <= 0:
		on_level_complete()
		

func set_lives_level_string(text_to_set):
	var new_string = str(text_to_set)
	if len(new_string) > 1:
		return new_string
	else:
		return "0" + new_string

func on_level_complete():
	level += 1
	if (level) >= level_count:
		$audioplayer.stream = snd_game_finished
		$audioplayer.play()
		ball_state = 3
		emit_signal("game_finished")
	else:
		$audioplayer.stream = snd_level_finished
		$audioplayer.play()
		ball_state = 0
		no_of_balls_in_play = 0
		emit_signal("level_finished")
		level_finished_timer.start()

func init_ball():
	var ball_node = ball.instance()
	ball_node.connect("got_brick", self, "_update_score")
	get_parent().call_deferred("add_child", ball_node)
	
func _on_Gamescreen_level_ready(bricks):
	brick_count = bricks
	label_level.set_text(set_lives_level_string(level + 1))


func _on_paddle_trigger_scene_change():
	$audioplayer.stream = snd_wall_hit
	$audioplayer.play()


func _on_paddle_trigger_level_change():
	on_level_complete()
