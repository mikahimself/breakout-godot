extends RigidBody2D

var paddle
var game_controller
var paddle_width

signal got_brick

# Called when the node enters the scene tree for the first time.
func _ready():
	paddle = get_parent().get_node("paddle")
	game_controller = get_parent().get_node("game_controller")
	paddle_width = paddle.get_child(0).frames.get_frame("default", 0).get_size().x
	mode = MODE_KINEMATIC
	# connect signals
	paddle.connect("ball_shot", self, "_on_paddle_ball_shot")
	get_parent().get_node("game_over_area").connect("body_entered", self, "_on_game_over_area_body_entered")

func _physics_process(delta):

	if (game_controller.ball_state == 1):
		# See if we're colliding with anything. Remember to enable contact_monitoring and set contacts_reported to at least 1.
		var bodies = get_colliding_bodies()

		if bodies.size() > 0:
			for body in bodies:
				if body.is_in_group("bricks"):
					emit_signal("got_brick", body.get_score())
					body.queue_free()
	
	elif (game_controller.ball_state == 0):
		position = Vector2(paddle.position.x + paddle_width / 2, paddle.position.y - 30)
		
func _on_paddle_ball_shot():
	set_linear_velocity(Vector2(200, -200))
	mode = MODE_RIGID

func _on_game_over_area_body_entered(body):
	queue_free()