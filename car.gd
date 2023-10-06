class_name Car extends VehicleBody3D

signal reset_car(target_position: Vector3)

var acceleration_speed = 2500
var BRAKE_FORCE = 20

var resetting = false
var reset_position = Vector3(0, 0, 0)

# Called when the node enters the scene tree for the first time.
func _ready():
	reset_car.connect(reset_to_position)


func reset_to_position(target_position):
	resetting = true
	reset_position = target_position


func _integrate_forces(state):
	if resetting:
		resetting = false
		state.transform.origin = reset_position

func _physics_process(delta):
	if Input.is_action_pressed("turn_right"):
		steering = lerp(steering, -0.6, delta * 3)
	if Input.is_action_pressed("turn_left"):
		steering = lerp(steering, 0.6, delta * 3)
	if not Input.is_action_pressed("turn_right") and not Input.is_action_pressed("turn_left"):
		steering = lerp(steering, 0.0, delta * 3)


func _unhandled_input(event):
	if event.is_action_pressed("accelerate"):
		engine_force = acceleration_speed
	if event.is_action_released("accelerate"):
		engine_force = 0
	
	if event.is_action_pressed("brake"):
		if linear_velocity.length() > 1:
			brake = BRAKE_FORCE
		else:
			engine_force = -acceleration_speed
	if event.is_action_released("brake"):
		brake = 0
