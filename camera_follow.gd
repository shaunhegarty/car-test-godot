extends Camera3D

@export var to_follow: Node
# Called when the node enters the scene tree for the first time.
func _ready():
	rotation.direction_to(to_follow.global_position)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	# rotation = rotation.direction_to(to_follow.global_position)
