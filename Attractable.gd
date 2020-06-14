extends RigidBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var FRICTION = 100


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	linear_velocity = linear_velocity.linear_interpolate(Vector2(0,0), FRICTION * delta)
