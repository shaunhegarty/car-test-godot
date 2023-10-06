extends VehicleBody3D



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func _input(event):
	if event.is_action_pressed("accelerate"):
		engine_force = 1800
	if event.is_action_released("accelerate"):
		engine_force = 0
	
	if event.is_action_pressed("brake"):
		brake = 50
	if event.is_action_released("brake"):
		brake = 0
	
	if event.is_action_pressed("turn_left"):
		steering = 0.6
	if event.is_action_released("turn_left"):
		steering = 0
	
	if event.is_action_pressed("turn_right"):
		steering = -0.6
	if event.is_action_released("turn_right"):
		steering = 0
