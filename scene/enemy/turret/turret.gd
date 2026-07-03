extends BaseEnemyClass




func  dead() -> void:
	if is_dead:
		return
	
	super.dead()
	
	is_dead = true
	%body_cont.hide()
	#%dead_timer.start(dead_time)
	%dead_player.play()
	collision_mask = 0 << 0
	for child in %dead_vfx.get_children():
		if child is GPUParticles3D:
			child.emitting = true
	
	for child in  %hit_zone_area_cont.get_children():
		if child is Area3D:
			child.monitorable = false


func st_dream(delta):
	if player_in_attack_area:
		change_state(State.ATTACK)

func st_attack(delta):
	if !player_in_attack_area:
		change_state(State.DREAM)
	#else:
		#if global_position.distance_to(player.global_position) >= 200.0:
			#player_in_attack_area = false
	
	if fire_rate_timer.is_stopped():
		fire_rate_timer.start(randf_range(enemy_res.fire_rite,enemy_res.fire_rite + 0.5))
		if player_is_see():
			shot()

	body_cont.look_at(player.global_position)
