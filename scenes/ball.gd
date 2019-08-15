extends RigidBody2D

var is_in_play = false
var paddle
var paddle_width

# Called when the node enters the scene tree for the first time.
func _ready():
	is_in_play = false
	paddle = get_parent().get_node("paddle")
	paddle_width = paddle.get_child(0).frames.get_frame("default", 0).get_size().x
	print(paddle_width)

func _physics_process(delta):

	if (is_in_play):
		# See if we're colliding with anything. Remember to enable contact_monitoring and set contacts_reported to at least 1.
		var bodies = get_colliding_bodies()

		if bodies.size() > 0:
			for body in bodies:
				if body.is_in_group("bricks"):
					body.queue_free()
	else:
		position = Vector2(paddle.position.x + paddle_width / 2, paddle.position.y - 30)