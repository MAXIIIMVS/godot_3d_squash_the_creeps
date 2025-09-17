extends CharacterBody3D

@export var speed := 14  # m/s
@export var fall_acceleration := 75  # m/s
@export var jump_impulse := 20  # m/s
@export var bounce_impulse := 16  # m/s
var target_velocity := Vector3.ZERO


func _physics_process(delta: float) -> void:
	var direction := Vector3.ZERO
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	# NOTE: Godot uses right hand coordinate system, so the XZ plane is the
	# ground
	if Input.is_action_pressed("move_forward"):
		direction.z -= 1
	if Input.is_action_pressed("move_back"):
		direction.z += 1

	if direction != Vector3.ZERO:
		direction = direction.normalized()
		$Pivot.basis = Basis.looking_at(direction)

	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed
	if not is_on_floor():
		target_velocity.y -= fall_acceleration * delta
	if is_on_floor() and Input.is_action_pressed("jump"):
		target_velocity.y = jump_impulse

	for index in range(get_slide_collision_count()):
		var collision := get_slide_collision(index)
		if collision.get_collider() == null:
			continue  # don't process duplicate collisions
		if collision.get_collider().is_in_group("mob"):
			var mob := collision.get_collider()
			# check if we are hitting from above
			if Vector3.UP.dot(collision.get_normal()) > 0.1:
				mob.squash()
				target_velocity.y = bounce_impulse
				break

	velocity = target_velocity
	move_and_slide()
