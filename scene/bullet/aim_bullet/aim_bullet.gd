extends BaseBullet

var target_node:Node3D = null

func set_target(new_target_node:Node3D) -> void:
	target_node = new_target_node


func  st_ph_attack(delta) -> void:
	if is_instance_valid(target_node):
		var target_dir: Vector3 = global_position.direction_to(target_node.global_position)
		

		direction = direction.move_toward(target_dir,1.0 * delta)

	var motion:Vector3 = direction * SPEED * delta

	var collision = move_and_collide(motion)

	if collision:
		var collider = collision.get_collider()
		if collider == GlobalData.player:
			SignalHub.emit_signal('playr_make_damage',damage)
		make_damage(collider)
		change_state(State.DEAD)
