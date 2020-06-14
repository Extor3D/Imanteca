extends KinematicBody2D

# Declare member variables here. Examples:
export var MAX_SPEED = 150  # How fast the player will move (pixels/sec).
export var MAGNET_DIST = 60
export var ACCEL = 20
export var FRICTION = 100
var screen_size  # Size of the game window.
var magnet_angle = 0
var velocity = Vector2.ZERO


# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	#hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	var input_vector = Vector2.ZERO  # The player's movement vector.	
	
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCEL)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION)
		
	velocity = move_and_slide(velocity)
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
	
	#$Magnet.position = self.position
	var mpos = get_global_mouse_position()
	magnet_angle = atan2(mpos.y - position.y, mpos.x - position.x);
	$Magnet.position.x = MAGNET_DIST * cos(magnet_angle)
	$Magnet.position.y = MAGNET_DIST * sin(magnet_angle)
	$Magnet.rotation = magnet_angle
	animate()

func animate():
	if velocity != Vector2.ZERO:
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()
		$AnimatedSprite.frame = 0
		
	if velocity.x != 0:
		$AnimatedSprite.animation = "walk_right"
		$AnimatedSprite.flip_v = false
		# See the note below about boolean assignment
		$AnimatedSprite.flip_h = velocity.x < 0
	elif velocity.y < 0:
		$AnimatedSprite.animation = "walk_up"
	elif velocity.y > 0:
		$AnimatedSprite.animation = "walk_down"

