extends StaticBody2D

var score setget set_score, get_score

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func get_score():
	return score
	
func set_score(value):
	score = value
