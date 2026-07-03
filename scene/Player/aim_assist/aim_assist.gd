extends Node3D

class_name AimAsistManager

@onready var main_camera:Camera3D = get_node('%head_camera')

@export var aim_cirkul_radius:float = 256.0

# Код внутри Player.gd или AimAssistant.gd
var current_target: Node3D = null

func _physics_process(delta: float) -> void:
	# Каждый физический кадр обновляем текущую цель
	current_target = update_aim_assist()
	global_transform = main_camera.global_transform

func get_huck_point() -> HuckSphere:
	if is_instance_valid(current_target):
		if current_target is HuckSphere:
			return current_target
	return null

func get_aim_target_point() -> Vector3:
	if is_instance_valid(current_target):
		return current_target.global_position
	
	# Если цели нет, отдаем точку в 10 метрах впереди камеры
	return %head_camera.global_position - (%head_camera.global_transform.basis.z * 10.0)

func update_aim_assist() -> Node3D:
	if not %aim_assist_area.has_overlapping_areas():
		return null
	return get_closest_enemy_in_screen_circle(%aim_assist_area.get_overlapping_areas())


func get_closest_enemy_in_screen_circle(enemy_area: Array) -> Node3D:
	if enemy_area.is_empty():
		return null
	
	var screen_center := get_viewport().get_visible_rect().size / 2
	var closest_enemy: Node3D = null
	var min_distance: float = aim_cirkul_radius
	var space := get_world_3d().direct_space_state

	for enemy in enemy_area:
		if not is_instance_valid(enemy): 
			continue
			
		# 1. Быстрая проверка на экране. Если мимо круга — луч пускать нет смысла.
		var enemy_screen_pos := main_camera.unproject_position(enemy.global_position)
		var distance_to_center := screen_center.distance_to(enemy_screen_pos)
		
		if distance_to_center >= min_distance:
			continue
			
		# 2. Проверка видимости (Raycast) только для тех, кто прошел первый фильтр
		var query := PhysicsRayQueryParameters3D.create(main_camera.global_position, enemy.global_position)
		query.collision_mask = (1 << 0) | (1 << 16)
		# query.exclude = [self] # Можно добавить исключение себя, если нужно
		
		var result := space.intersect_ray(query)
		if result:
			# Если луч встретил что-то, что не является этим врагом (или его владельцем) — значит враг за стеной
			if result.collider != enemy and result.collider != enemy.get_owner():
				continue
		
		# Если дошли сюда, значит враг ближе всех и виден
		min_distance = distance_to_center
		closest_enemy = enemy

	return closest_enemy
