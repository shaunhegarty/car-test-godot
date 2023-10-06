@tool
extends Camera3D

@export var marker_position: Node3D
@export var follow_object: Node3D


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
		follow_object.rotate_object_local(Vector3.UP, event.relative.x * -0.002)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	global_position = global_position.lerp(marker_position.global_position, 2 * delta)
	look_at(follow_object.global_transform.origin, Vector3(0, 1, 0))

	if not rotate_camera:
		follow_object.transform.basis = follow_object_initial_transform.basis
