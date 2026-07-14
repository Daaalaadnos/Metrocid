extends EC_Base


func shot() -> void:
	var current_move:ColoneBossAttack = enemy.current_move
	if current_move == null:
		return
	
	#for bullet_marker in shot_mark_cont.get_children():
		#if bullet_marker is not Marker3D:
			#continue
		
		
		#for a in range(enemy_res.bullet_in_shot):

			
	var bullet:BaseBullet = current_move.bullet_scene.instantiate()
	get_tree().current_scene.add_child(bullet)

	# Ставим пулю на дуло
	var shot_mark:Marker3D = get_tree().current_scene.get_node(current_move.shot_marker)
	bullet.global_position = shot_mark.global_position

	var direction: Vector3 = -shot_mark.global_transform.basis.z
	var sprad_dir := direction
	var sped = current_move.spred
	sprad_dir = sprad_dir.rotated(Vector3.FORWARD, deg_to_rad(randf_range(-sped,sped)))
	sprad_dir = sprad_dir.rotated(Vector3.RIGHT, deg_to_rad(randf_range(-sped,sped)))
	#bullet.set_start(sprad_dir,bullet_res,player,true)
	bullet.set_collision(true)
	bullet.direction = sprad_dir
	bullet.damage = current_move.damage
	bullet.SPEED = current_move.bullet_speed
	if current_move.bullet_visual != null:
		bullet.add_visual(current_move.bullet_visual)
	
	%shot_player.play()

func simp_shot(bullet_scene:PackedScene,shot_mark_cont:Node3D) -> void:
	for bullet_marker in shot_mark_cont.get_children():
		if bullet_marker is not Marker3D:
			continue

		var bullet = bullet_scene.instantiate()
		get_tree().current_scene.add_child(bullet)

		bullet.global_position = bullet_marker.global_position

		var direction: Vector3 = -bullet_marker.global_transform.basis.z
		bullet.direction = direction
		%shot_player.play()


## Пример логики внутри shot_manager для выстрела кольцом
#func shot_ring(bullet_stats: BulletStats, count: int = 8):
	#var angle_step = 360.0 / count
	#
	#for i in range(count):
		#var bullet = bullet_stats.bullet_scene.instantiate()
		#get_tree().current_scene.add_child(bullet)
		#
		## Ставим пулю в позицию босса
		#bullet.global_position = bullet_start_markers_area[0].global_position
		#
		## Высчитываем направление по кругу
		#var angle_rad = deg_to_rad(i * angle_step)
		## Берем базис крутящегося нода, чтобы кольцо было ориентировано на игрока,
		## либо просто стреляем в плоскости XZ (по полу арены)
		#var direction = Vector3(cos(angle_rad), 0, sin(angle_rad)).normalized()
		#var final_dir = direction.rotated(Vector3.FORWARD,randf_range(-90,90))
		#
		#bullet.set_start(final_dir,bullet_stats,player,true)
