extends BaseBullet

func st_ph_attack(delta) -> void:
	if not direction:
		return

	velocity = direction * SPEED * delta

	var collision = move_and_collide(velocity)
	if collision:
		var collider = collision.get_collider()
		if collider == GlobalData.player:
			SignalHub.emit_signal('playr_make_damage',damage)
		make_damage(collider)
		change_state(State.DEAD)
