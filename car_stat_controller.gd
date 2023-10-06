extends CanvasLayer

@export var vehicle: VehicleBody3D

# Vehicle parameter controls
@export var friction_spinner: SpinBox
@export var stiffness_spinner: SpinBox
@export var rest_spinner: SpinBox
@export var travel_spinner: SpinBox
@export var roll_influence_spinner: SpinBox
@export var damping_compression_spinner: SpinBox
@export var damping_relaxation_spinner: SpinBox

# Vehicle stats display controls
@export var speed_label: Label
@export var wheel_info_label: Label

# Vehicle Reset
@export var reset_button: Button

# Vehicle Parts
@export var wheels: Array[VehicleWheel3D] = []

# Vehicle Initial State
var initial_car_position: Vector3
var initial_car_rotation: Vector3

# Called when the node enters the scene tree for the first time.
func _ready():
	initial_car_position = vehicle.global_position
	initial_car_rotation = vehicle.global_rotation

	friction_spinner.value_changed.connect(update_wheels)
	stiffness_spinner.value_changed.connect(update_wheels)
	rest_spinner.value_changed.connect(update_wheels)
	travel_spinner.value_changed.connect(update_wheels)
	roll_influence_spinner.value_changed.connect(update_wheels)
	reset_button.pressed.connect(reset_car_position)
	damping_compression_spinner.value_changed.connect(update_wheels)
	damping_relaxation_spinner.value_changed.connect(update_wheels)

	update_wheels()


func update_wheels(_update_value=null):
	for wheel in wheels:
		wheel.wheel_friction_slip = friction_spinner.value
		wheel.wheel_rest_length = rest_spinner.value
		wheel.suspension_stiffness = stiffness_spinner.value
		wheel.suspension_travel = travel_spinner.value
		wheel.wheel_roll_influence = roll_influence_spinner.value
		wheel.damping_compression = damping_compression_spinner.value
		wheel.damping_relaxation = damping_relaxation_spinner.value


func update_stats():
	var speed_mps = vehicle.linear_velocity.length()
	var speed_kph = speed_mps * 3.6
	speed_label.text = "Speed: %d" % speed_kph
	var wheel_info_text = ""
	var count = 0
	for wheel in wheels:
		count += 1
		wheel_info_text += "Wheel %s RPM: %d\n" % [count, wheel.get_rpm()]
	wheel_info_label.text = wheel_info_text


func reset_car_position():
	vehicle.global_position = initial_car_position
	vehicle.global_rotation = initial_car_rotation
	vehicle.angular_velocity = Vector3.ZERO
	vehicle.linear_velocity = Vector3.ZERO

func _process(_delta):
	update_stats()
