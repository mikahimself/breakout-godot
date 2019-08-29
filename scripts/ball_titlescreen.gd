extends KinematicBody2D

var speed = 0
var direction = Vector2()
var velocity = Vector2()

func _ready():
	set_physics_process(true)


func _physics_process(delta):

	var collision_info = move_and_collide(velocity * delta)

	if collision_info:
		var body = collision_info.collider

		if body.is_in_group("bricks"):
			body.queue_free()
			velocity = velocity.bounce(collision_info.normal)
		else:
			velocity = velocity.bounce(collision_info.normal)

func _on_ball_timer_timeout():
	show()
	speed = 250
	direction = Vector2(200, -200).normalized()
	velocity = speed * direction
