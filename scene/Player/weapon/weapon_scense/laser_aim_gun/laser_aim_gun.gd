extends BassWeapon


func set_bullet_data(bullet):
	super.set_bullet_data(bullet)
	if bullet.has_method('set_target'):
		bullet.set_target(target_node)
		bullet.velocity = -global_transform.basis.z * 30.0
