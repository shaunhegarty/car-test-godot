class_name Car extends VehicleBody3D

signal reset_car(p_transform: Transform3D )
signal handbrake(p_active: bool )

var acceleration_speed = 2500
var BRAKE_FORCE = 20

var resetting = false
var reset_transform: = Transform3D()

# Called when the node enters the scene tree for the first time.
func _ready():
	reset_car.connect(reset_transform_to_initial)


func reset_transform_to_initial(target_transform: Transform3D):
	resetting = true
	reset_transform = target_transform



func _integrate_forces(state):
	if resetting:
		resetting = false
		state.transform = reset_transform

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
	
	if event.is_action_pressed("handbrake"):
		handbrake.emit(true)
	if event.is_action_released("handbrake"):
		handbrake.emit(false)
	
	if event.is_action_pressed("ui_cancel") or event.is_action_pressed("ui_accept"):
		var focus_owner = get_viewport().gui_get_focus_owner()
		if focus_owner:
			focus_owner.release_focus()
