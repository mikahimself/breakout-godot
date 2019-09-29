extends KinematicBody2D

export var speed = 300
var velocity = Vector2()

# Scenes & items
var tween
var sprite
var collider
var game_controller

# Bools
var tweendirection
var tweenstart
var level_ready

# Signalling
signal ball_shot
signal trigger_scene_change
signal trigger_level_change

# Called when the node enters the scene tree for the first time.
func _ready():
	position = Vector2(384, 400)
	tween = $paddle_tween
	sprite = $paddle_sprite
	collider = $paddle_collider
	game_controller = get_parent().get_node("game_controller")
	tweenstart = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	get_controls()

func _physics_process(delta):
	move_and_collide(velocity * delta)

func get_controls():
	if level_ready:
		if (Input.is_key_pressed(KEY_LEFT)):
			velocity.x = -1
		elif (Input.is_key_pressed(KEY_RIGHT)):
			velocity.x = 1
		else:
			velocity.x = 0
		velocity = velocity.normalized() * speed

		if (Input.is_key_pressed(KEY_SPACE)):
			if game_controller.ball_state == 0 and game_controller.no_of_balls_in_play == 0:
				emit_signal("ball_shot")
			elif game_controller.ball_state == 3:
				emit_signal("trigger_scene_change")
		if (Input.is_key_pressed(KEY_T)):
			emit_signal("trigger_level_change")
	#if (Input.is_key_pressed(KEY_SPACE) && tweenstart == false):
	#	tweendirection = !tweendirection
	#	tweenstart = true
	#	change_size(tweendirection)

func change_size(change_to_big):
	if (change_to_big):
		tween.interpolate_property(sprite, "scale", Vector2(2,2), (Vector2(3, sprite.scale.y)), 0.75, Tween.TRANS_ELASTIC, Tween.EASE_IN)
		tween.connect("tween_completed", self, "_on_scale_complete", [], CONNECT_ONESHOT)
		tween.start()
	else:
		tween.interpolate_property(sprite, "scale", sprite.scale, (Vector2(sprite.scale.x * 0.5, sprite.scale.y)), 0.75, Tween.TRANS_ELASTIC, Tween.EASE_IN)
		tween.connect("tween_completed", self, "_on_scale_complete", [], CONNECT_ONESHOT)
		tween.start()

func swap_sprite():
	if (tweendirection):
		sprite.set_frame(1)
		sprite.scale = Vector2(2,2)
		collider.scale = Vector2(1.5, 1)
	else:
		sprite.set_frame(0)
		sprite.scale = Vector2(2,2)
		collider.scale = Vector2(1, 1)

func _on_scale_complete(obj, key):
	swap_sprite()
	tweenstart = false

func _on_Gamescreen_level_ready(bricks):
	level_ready = true

func _on_game_controller_level_finished():
	level_ready = false
