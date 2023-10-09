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


# Vehicle Initial State
var initial_car_position: Transform3D

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
	vehicle.values_updated.connect(update_balance_labels)

	update_wheels()
	update_acceleration()


func update_acceleration(_update_value=null):
	vehicle.acceleration_speed = acceleration_spinner.value


func update_wheels(_update_value=null):
	vehicle.set_wheel_rest_length(rest_spinner.value)
	vehicle.set_wheel_roll_influence(roll_influence_spinner.value)
	vehicle.set_suspension_stiffness(stiffness_spinner.value)
	vehicle.set_suspension_max_force(max_force_spinner.value)
	vehicle.set_suspension_travel(travel_spinner.value)
	vehicle.set_damping_compression(damping_compression_spinner.value)
	vehicle.set_damping_relaxation(damping_relaxation_spinner.value)

	vehicle.set_grip_balance(balance_slider.value)
	vehicle.set_friction_slip(friction_spinner.value)

	update_balance_labels()

func update_balance_labels():
	balance_label_front.text = "%.2f" % vehicle.get_forward_balance()
	balance_label_rear.text = "%.2f" % vehicle.get_rear_balance()

func update_stats():
	var speed_mps = vehicle.linear_velocity.length()
	var speed_kph = speed_mps * 3.6
	speed_label.text = "Speed: %d" % speed_kph
	var wheel_info_text = ""
	for wheel in vehicle.front_wheels + vehicle.rear_wheels:
		wheel_info_text += "%s RPM: %d\n" % [wheel.name, wheel.get_rpm()]
	wheel_info_label.text = wheel_info_text


func reset_car_position():
	vehicle.reset_car()

func _process(_delta):
	update_stats()
