extends KinematicBody2D

var paddle
var game_controller
var paddle_width
var anchor_point_y = 10

const SPEEDUP = 10
const MAX_SPEED = 400

var speed = 0
var direction = Vector2()
var velocity = Vector2()


signal got_brick

# Called when the node enters the scene tree for the first time.
func _ready():
	set_physics_process(true)

	paddle = get_parent().get_node("paddle")
	game_controller = get_parent().get_node("game_controller")
	paddle_width = paddle.get_node("paddle_sprite").frames.get_frame("default", 0).get_size().x

	# connect signals
	paddle.connect("ball_shot", self, "_on_paddle_ball_shot")
	get_parent().get_node("game_over_area").connect("body_entered", self, "_on_game_over_area_body_entered")

func _physics_process(delta):

	if (game_controller.ball_state == 1):
		var collision_info = move_and_collide(velocity * delta)

		if collision_info:
			var body = collision_info.collider

			if body.is_in_group("bricks"):
				emit_signal("got_brick", body.get_score())
				body.queue_free()
				velocity = velocity.bounce(collision_info.normal)

			elif body.get_name() == "paddle":
				var anchor_pos = Vector2(body.get_global_position().x, body.get_global_position().y + anchor_point_y)
				var direction = get_position() - anchor_pos
				
				if (get_position().x + 8 < body.get_global_position().x - paddle_width) or (get_position().x - 8 > body.get_global_position().x + paddle_width):
					velocity = velocity.bounce(collision_info.normal)
				else:
					velocity = direction.normalized() * min(velocity.length() + SPEEDUP, MAX_SPEED)

				# print(velocity.length())

			else:
				velocity = velocity.bounce(collision_info.normal)

	elif (game_controller.ball_state == 0):
		position = Vector2(paddle.position.x, paddle.position.y - 40)

func _on_paddle_ball_shot():
	speed = 250
	direction = Vector2(200, -200).normalized()
	velocity = speed * direction


func _on_game_over_area_body_entered(body):
	queue_free()