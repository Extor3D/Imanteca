extends Area2D

export var RANGE = 100
export var ARC = 45
export var INTENSITY = 10


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var currentTotalForce = Vector2(0,0)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	$MagnetSprite.animation = "idle"
	update()

func _physics_process(_delta):
	var shape = ConvexPolygonShape2D.new()
	var points = getArcPoints(Vector2.ZERO, RANGE, 90 - ARC/2, 90 + ARC/2, 32)
	points.push_back(Vector2.ZERO)
	points.push_back(points[0])
	shape.set_point_cloud(points)
	$MagnetInfluence/MagnetAttractCollision.set_shape(shape)
	
	for i in $MagnetInfluence.get_overlapping_bodies():
		if i != self:
			var dist : float = (i.get_position() - global_position).length()
			var attractStrength : float = INTENSITY / (0.1 + (dist/200))
			var attractDirection : Vector2 = (global_position - i.get_position()).normalized()
			i.apply_impulse(Vector2.ZERO, attractDirection * attractStrength)

	currentTotalForce = Vector2(0,0)

func _draw():
	var color = Color(1.0, 0.0, 0.0)
	draw_circle_arc(Vector2.ZERO, RANGE, 90 - ARC/2, 90 + ARC/2, color)

func draw_circle_arc(center, radius, angle_from, angle_to, color):
	var nb_points = 32
	var points_arc = getArcPoints(center, radius, angle_from, angle_to, nb_points)

	for index_point in range(nb_points):
		draw_line(points_arc[index_point], points_arc[index_point + 1], color)

func getArcPoints(center, radius, angle_from, angle_to, points):
	var points_arc = PoolVector2Array()

	for i in range(points + 1):
		var angle_point = deg2rad(angle_from + i * (angle_to-angle_from) / points - 90)
		points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radius)
	
	return points_arc
