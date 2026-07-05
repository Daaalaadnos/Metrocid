extends BaseBullet

func st_ph_attack(delta) -> void:
	if not direction:
		return

	var motion:Vector3 = direction * SPEED * delta

	var collision = move_and_collide(motion)
	if collision:
		var collider = collision.get_collider()
		if collider == GlobalData.player:
			SignalHub.emit_signal('playr_make_damage',damage)
		make_damage(collider)
		change_state(State.DEAD)
