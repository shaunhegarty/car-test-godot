class_name Car extends VehicleBody3D


var acceleration_speed = 2500


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	if Input.is_action_pressed("turn_right"):
		steering = lerp(steering, -0.6, delta * 3)
	if Input.is_action_pressed("turn_left"):
		steering = lerp(steering, 0.6, delta * 3)
	if not Input.is_action_pressed("turn_right") and not Input.is_action_pressed("turn_left"):
		steering = lerp(steering, 0.0, delta * 3)


func _input(event):
	if event.is_action_pressed("accelerate"):
		engine_force = acceleration_speed
	if event.is_action_released("accelerate"):
		engine_force = 0
	
	if event.is_action_pressed("brake"):
		brake = 50
	if event.is_action_released("brake"):
		brake = 0
