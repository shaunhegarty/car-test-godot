extends CanvasLayer

@export var vehicle: Car

# Vehicle parameter controls
@export var acceleration_spinner: SpinBox
@export var friction_spinner: SpinBox
@export var balance_slider: HSlider
@export var rest_spinner: SpinBox
@export var roll_influence_spinner: SpinBox
@export var stiffness_spinner: SpinBox
@export var max_force_spinner: SpinBox
@export var travel_spinner: SpinBox
@export var damping_compression_spinner: SpinBox
@export var damping_relaxation_spinner: SpinBox

# Vehicle stats display controls
@export var speed_label: Label
@export var wheel_info_label: Label
@export var balance_label_front: Label
@export var balance_label_rear: Label

# Vehicle Reset
@export var reset_button: Button

# Vehicle Parts
@export var front_wheels: Array[VehicleWheel3D] = []
@export var rear_wheels: Array[VehicleWheel3D] = []

# Vehicle Initial State
var initial_car_position: Transform3D
var is_handbraking = false

# Called when the node enters the scene tree for the first time.
func _ready():
	initial_car_position = vehicle.global_transform

	acceleration_spinner.value_changed.connect(update_acceleration)

	friction_spinner.value_changed.connect(update_wheels)
	balance_slider.value_changed.connect(update_wheels)

	rest_spinner.value_changed.connect(update_wheels)
	roll_influence_spinner.value_changed.connect(update_wheels)
	stiffness_spinner.value_changed.connect(update_wheels)
	max_force_spinner.value_changed.connect(update_wheels)
	travel_spinner.value_changed.connect(update_wheels)
	damping_compression_spinner.value_changed.connect(update_wheels)
	damping_relaxation_spinner.value_changed.connect(update_wheels)
	
	reset_button.pressed.connect(reset_car_position)
	vehicle.handbrake.connect(set_handbrake)

	update_wheels()
	update_acceleration()


func set_handbrake(_is_handbraking):
	is_handbraking = _is_handbraking
	update_wheels()


func update_acceleration(_update_value=null):
	vehicle.acceleration_speed = acceleration_spinner.value


func update_wheels(_update_value=null):
	for wheel in front_wheels + rear_wheels:
		wheel.wheel_rest_length = rest_spinner.value
		wheel.wheel_roll_influence = roll_influence_spinner.value
		wheel.suspension_stiffness = stiffness_spinner.value
		wheel.suspension_max_force = max_force_spinner.value
		wheel.suspension_travel = travel_spinner.value
		wheel.damping_compression = damping_compression_spinner.value
		wheel.damping_relaxation = damping_relaxation_spinner.value
	
	var forward_balance: float
	var rear_balance: float
	
	if is_handbraking:
		forward_balance = 1
		rear_balance = 0.1
	else:	
		forward_balance = min(balance_slider.value, 0.5) / balance_slider.value
		rear_balance = min(1 - balance_slider.value, 0.5) / (1 - balance_slider.value)

	balance_label_front.text = "%.2f" % forward_balance
	balance_label_rear.text = "%.2f" % rear_balance

	for wheel in front_wheels:
		wheel.wheel_friction_slip = friction_spinner.value * forward_balance
	
	for wheel in rear_wheels:
		wheel.wheel_friction_slip = friction_spinner.value * rear_balance


func update_stats():
	var speed_mps = vehicle.linear_velocity.length()
	var speed_kph = speed_mps * 3.6
	speed_label.text = "Speed: %d" % speed_kph
	var wheel_info_text = ""
	for wheel in front_wheels + rear_wheels:
		wheel_info_text += "%s RPM: %d\n" % [wheel.name, wheel.get_rpm()]
	wheel_info_label.text = wheel_info_text


func reset_car_position():
	vehicle.reset_car.emit(initial_car_position)

func _process(_delta):
	update_stats()
