class_name Player

extends CharacterBody3D

const SPEED = 3
const JUMP_VELOCITY = 4.5


@onready var head := $Camera3D;


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


const MOUSE_SENSITIVITY = 0.0008;
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * MOUSE_SENSITIVITY)
		head.rotation.x = clamp(head.rotation.x - event.relative.y * MOUSE_SENSITIVITY, -1.5, 1.5)

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity += up_direction * JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "up", "down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	var clamping_factor = 12 if is_on_floor() else 5

	# if direction.length() > 0.1:
	# 	$chumps/AnimationPlayer.current_animation = "Walk1"
	# else:
	# 	$chumps/AnimationPlayer.current_animation = "Idle"

	velocity.x = lerp(velocity.x, direction.x * SPEED, clamping_factor * delta)
	velocity.z = lerp(velocity.z, direction.z * SPEED, clamping_factor * delta)



	move_and_slide()
