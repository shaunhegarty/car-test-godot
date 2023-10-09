class_name Car extends VehicleBody3D

signal reset_car(p_transform: Transform3D )
signal values_updated

# Vehicle Parts
@export var front_wheels: Array[VehicleWheel3D] = []
@export var rear_wheels: Array[VehicleWheel3D] = []


var acceleration_speed = 2500
var BRAKE_FORCE = 20

var is_braking = false
var is_handbraking = false
var grip_balance = 0.5
var friction_slip = 1.0

var resetting = false
var reset_transform: = Transform3D()


# Called when the node enters the scene tree for the first time.
func _ready():
	reset_car.connect(reset_transform_to_initial)


func reset_transform_to_initial(target_transform: Transform3D):
	resetting = true
	reset_transform = target_transform


func set_wheel_rest_length(p_length: float ):
	for wheel in front_wheels + rear_wheels:
		wheel.wheel_rest_length = p_length


func set_wheel_roll_influence(p_influence: float ):
	for wheel in front_wheels + rear_wheels:
		wheel.wheel_roll_influence = p_influence
	
	
func set_suspension_stiffness(p_stiffness: float ):
	for wheel in front_wheels + rear_wheels:
		wheel.suspension_stiffness = p_stiffness


func set_suspension_max_force(p_force: float ):
	for wheel in front_wheels + rear_wheels:
		wheel.suspension_max_force = p_force


func set_suspension_travel(p_travel: float ):
	for wheel in front_wheels + rear_wheels:
		wheel.suspension_travel = p_travel


func set_damping_compression(p_damping_compression: float ):
	for wheel in front_wheels + rear_wheels:
		wheel.damping_compression = p_damping_compression


func set_damping_relaxation(p_damping_relaxation: float ):
	for wheel in front_wheels + rear_wheels:
		wheel.damping_relaxation = p_damping_relaxation


func pull_handbrake():
	is_handbraking = true
	for wheel in rear_wheels:
		wheel.brake = BRAKE_FORCE * 2
	set_wheel_friction()


func release_handbrake():
	is_handbraking = false
	for wheel in rear_wheels:
		wheel.brake = 0
	set_wheel_friction()


func set_grip_balance(p_grip_balance: float):
	grip_balance = clamp(p_grip_balance, 0, 1)
	set_wheel_friction()

func set_friction_slip(p_friction_slip: float):
	print("setting friction slip from %.1f to: %.1f "% [friction_slip, p_friction_slip])
	friction_slip = p_friction_slip
	set_wheel_friction()

func set_wheel_friction():
	var forward_balance = get_forward_balance()
	var rear_balance = get_rear_balance()
	if is_handbraking:
		forward_balance = 1
		rear_balance = 0.1

	for wheel in front_wheels:
		wheel.wheel_friction_slip = friction_slip * forward_balance
	
	for wheel in rear_wheels:
		wheel.wheel_friction_slip = friction_slip * rear_balance
	
	values_updated.emit()
	


func get_forward_balance() -> float:
	var grip_balance_to_use = grip_balance
	if is_handbraking:
		grip_balance_to_use = 0.1
	
	if grip_balance_to_use > 0:
		return min(grip_balance_to_use, 0.5) / grip_balance_to_use
	else:
		return 1
	
func get_rear_balance() -> float:
	var grip_balance_to_use = grip_balance
	if is_handbraking:
		grip_balance_to_use = 0.1
		
	if 1 - grip_balance_to_use != 0:
		return min(1 - grip_balance_to_use, 0.5) / (1 - grip_balance_to_use)
	else:
		return 1


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
			is_braking = true
			brake = BRAKE_FORCE
		else:
			engine_force = -acceleration_speed
	if event.is_action_released("brake"):
		brake = 0
	
	if event.is_action_pressed("handbrake"):
		pull_handbrake()
		set_wheel_friction()
	if event.is_action_released("handbrake"):
		is_handbraking = false
		set_wheel_friction()
	
	if event.is_action_pressed("ui_cancel") or event.is_action_pressed("ui_accept"):
		var focus_owner = get_viewport().gui_get_focus_owner()
		if focus_owner:
			focus_owner.release_focus()
