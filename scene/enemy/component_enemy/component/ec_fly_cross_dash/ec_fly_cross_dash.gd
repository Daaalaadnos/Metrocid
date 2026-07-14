extends EC_Base



@export var dash_max_dist_to_pl:float = 12.0
@export var dash_min_dist_to_pl:float = 7.0

@onready var wall_cast:RayCast3D = %wall_cast
@onready var dash_timer: Timer = %dash_timer

func _physics_process(delta: float) -> void:
	
	if enemy.player_in_attack_area:
		var target:Vector3
		target = player.global_position
		desh(target)
		
		var dir_to_target:Vector3 = enemy.global_position.direction_to(target)
		
		var rot_y = atan2(-dir_to_target.x,-dir_to_target.z)
		enemy.global_rotation.y = lerp_angle(enemy.global_rotation.y,rot_y,delta * 5.0)
		
		var horizontal_dist = Vector2(dir_to_target.x, dir_to_target.z).length()
		var rot_x = atan2(dir_to_target.y, horizontal_dist)
		rot_x = clamp(rot_x, deg_to_rad(-45.0), deg_to_rad(45.0))
		enemy.global_rotation.x = lerp_angle(enemy.global_rotation.x, rot_x, delta * 5.0)
	
	enemy.velocity.x = lerp(enemy.velocity.x, 0.0, delta * 5.0)
	enemy.velocity.z = lerp(enemy.velocity.z, 0.0, delta * 5.0)
	

func desh(target_:Vector3) -> void:
	if !dash_timer.is_stopped():
		return
	
	dash_timer.start()

	var dist_to_pl = (enemy.global_position * Vector3(1,0,1)).distance_to(target_ * Vector3(1,0,1))
	
	
	var target_point:Vector3
	if dist_to_pl < dash_min_dist_to_pl or dist_to_pl > dash_max_dist_to_pl:
		var pos_player := target_
		var pos_mob := enemy.global_position
		
		var dir_flat := Vector3(pos_player.x - pos_mob.x, 0, pos_player.z - pos_mob.z).normalized()
		
		target_point = pos_player - (dir_flat * dash_min_dist_to_pl)

	else:
		var back_dir := Vector3(enemy.global_position.x - target_.x, 0, enemy.global_position.z - target_.z).normalized()

		var side_modifier: float = [-1.0, 1.0][randi_range(0, 1)]

		var angle := deg_to_rad(randf_range(10,120)) * side_modifier

		var orbit_dir := back_dir.rotated(Vector3.UP, angle)
		
		target_point = target_ + (orbit_dir * (dash_min_dist_to_pl + 2.0))
	
	target_point.y = target_.y + randf_range(3,5)
	
	# Проверяем препятствия. Функция вернет безопасную ГЛOБАЛЬНУЮ точку
	var final_point: Vector3 = check_obstacles(target_point)
	
	#var impuls = global_position.direction_to(final_point) * global_position.distance_to(final_point)
	
	#velocity = impuls
	
	tween_move(final_point)

func check_obstacles(target_position: Vector3) -> Vector3:
	wall_cast.global_position = enemy.global_position
	wall_cast.target_position = wall_cast.to_local(target_position)
	
	wall_cast.force_raycast_update()
	
	if wall_cast.is_colliding():
		# Если впереди стена, берем точку удара
		var hit_point = wall_cast.get_collision_point()
		if enemy.global_position.distance_to(hit_point) <= 2.0:
			return enemy.global_position
		# И отступаем от нее назад к мобу на 1.5 метра, чтобы не застрять в текстуре
		var safe_direction = hit_point.direction_to(enemy.global_position)
		return hit_point + safe_direction * 1.5
	
	# Если стен нет, спокойно летим в изначально задуманную точку
	return target_position

func tween_move(target_point:Vector3) -> void:

	var tween := create_tween()
	
	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_ease(Tween.EASE_OUT)
	
	tween.tween_property(enemy,'global_position',target_point,dash_timer.wait_time / 3)
	tween.finished.connect(func():
			pass
			enemy.velocity = Vector3.ZERO # Сбрасываем скорость после остановки
	)
