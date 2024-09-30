extends CharacterBody3D

@onready var agent: NavigationAgent3D = $NavigationAgent3D

@onready var anim_tree: AnimationTree = $AnimationTree

const SPEED = 3

func _unhandled_input(event: InputEvent) -> void:
	if (event.is_action_pressed("ui_accept")):
		var player: Player = get_tree().get_nodes_in_group("player")[0]
		if player:
			agent.set_target_position(player.global_position)

func _physics_process(delta) -> void:
	var destination = agent.get_next_path_position()
	var local_destination = destination - global_position
	local_destination.y = 0

	var direction = local_destination.normalized() if local_destination.length() > 0.1 else Vector3.ZERO

	if direction.length() > 0.1:
		anim_tree.set("parameters/Movement/transition_request", "Walk")

		# Rotate towards the current direction
		# look_at(global_position + direction, Vector3.UP)

		rotation.y=lerp(rotation.y,atan2(-velocity.x,-velocity.z),.1)
	else:
		anim_tree.set("parameters/Movement/transition_request", "Idle")


	direction *= SPEED
	anim_tree.set("parameters/WalkSpeed/scale", direction.length() / 3.5)

	velocity.x = lerp(velocity.x, direction.x, 12 * delta)
	velocity.z = lerp(velocity.z, direction.z, 12 * delta)

	if not is_on_floor():
		velocity += get_gravity() * delta

	move_and_slide()
