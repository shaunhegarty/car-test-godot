@tool
extends Camera3D

@export var marker_position: Node3D
@export var follow_object: Node3D

@export var max_distance = 5
@export var max_distance_smoothness = 4


var follow_object_initial_transform: Transform3D


func _ready():
	follow_object_initial_transform.basis = follow_object.transform.basis


var rotate_camera = false

func _unhandled_input(event):
	if event is InputEventMouseButton and event.is_action_pressed("camera_rotate"):
		rotate_camera = true
	if event is InputEventMouseButton and event.is_action_released("camera_rotate"):
		rotate_camera = false

	if event is InputEventMouseMotion and rotate_camera:
		follow_object.rotate_object_local(Vector3.UP, event.relative.x * -0.003)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):

	var distance = global_position.distance_to(marker_position.global_position)
	if distance / max_distance > 2:
		global_position = marker_position.global_position
	else:
		var speed_multiplier = max((distance ** max_distance_smoothness) / (max_distance ** max_distance_smoothness), 2)
		global_position = global_position.lerp(marker_position.global_position, speed_multiplier * delta)
		look_at(follow_object.global_transform.origin, Vector3(0, 1, 0))

	if not rotate_camera:
		follow_object.transform.basis = follow_object_initial_transform.basis
