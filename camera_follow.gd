@tool
extends Camera3D

@export var marker_position: Node
@export var follow_object: Node


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	global_position = global_position.lerp(marker_position.global_position, 2 * delta)
	look_at(follow_object.global_transform.origin, Vector3(0, 1, 0))
