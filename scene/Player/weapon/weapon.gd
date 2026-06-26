extends Node3D

class_name BassWeapon1

enum State{IDLE,CHANGE,CHARGE,SHOT,RELOAD}
var state = State.IDLE
var nex_state = null

@onready var main_camera:Camera3D = get_node('%head_camera')
@onready var anim_player:AnimationPlayer = get_node('%weapon_anim_pl')

@onready var fire_rate_timer:Timer = get_node('%fire_rate_timer')

@onready var aim_area:Area3D = get_node('%aim_assist_area')

@onready var weapon_cont:Node3D = get_node('%weapon_cont')

@export var WpRes:WeaponRes
@export var WpInvent:WpInven

var target_node:Node3D

func _input(event: InputEvent) -> void:
	match state:
		State.IDLE:
			if event.is_action_pressed('shot'):
				if WpRes.charge:
					change_state(State.CHARGE)
					return
				change_state(State.SHOT)
			if event.is_action_pressed('charge'):
				if !is_instance_valid(target_node):
					return
				if target_node.is_in_group('huck_point'):
					owner.huck_node(target_node)
			
			if Input.is_action_just_pressed('1'):
				change_weapon(0)
			if Input.is_action_just_pressed('2'):
				change_weapon(1)
			if Input.is_action_just_pressed('3'):
				change_weapon(2)

func change_weapon(new_id) -> void:
	var new_weapon = WpInvent.get_weapon(new_id)
	if new_weapon == null or WpRes == new_weapon:
		return
	WpRes = new_weapon
	%weapn_name.text = WpRes.name
	change_state(State.CHANGE)

func _ready() -> void:
	change_weapon(0)
	fire_rate_timer.wait_time = WpRes.fire_rate

func change_state(new_state:State) -> void:
	if new_state == null:
		return
	nex_state = new_state

func aplly_change_state() -> void:
	if nex_state == null:
		return
	
	match nex_state:
		State.IDLE:
			anim_player.play('idle')
		State.CHARGE:
			anim_player.play('charge')
			%charge_timer.start(WpRes.charge_time)
		State.CHANGE:
			anim_player.play('change')
			%weapon_change_timer.start(1.5)
		
		
		State.SHOT:
			anim_player.stop()
			anim_player.play('shot')
			var rand_fire_rate = (randf_range(WpRes.fire_rate,WpRes.fire_rate * 1.3))
			fire_rate_timer.start(rand_fire_rate)
			shot()
			%shot_player.play()
			%vfx_shot_spark.restart()
			%sparks.restart()
			
	state = nex_state
	nex_state = null




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	match state:
		State.IDLE:
			st_idle(delta)
		State.CHANGE:
			st_change(delta)
		State.CHARGE:
			st_charge(delta)
		State.SHOT:
			st_shot(delta)
	
	weapon_aim(delta)
	
	WpRes.spred = clampf(WpRes.spred - delta * WpRes.spred_damp_mod,WpRes.min_spred,WpRes.max_spred)
	%Aim_point.update_scale_from_sprad(remap(WpRes.spred,WpRes.min_spred,WpRes.max_spred,0.2,1.5))
	
	global_transform = %head_camera.global_transform
	aplly_change_state()

func st_idle(delta) -> void:
	pass

func st_change(delta) -> void:
	if %weapon_change_timer.is_stopped():
		change_state(State.IDLE)

func st_shot(delta):
	if fire_rate_timer.is_stopped():
		if Input.is_action_pressed('shot'):
			change_state(State.SHOT)
			return
		change_state(State.IDLE)

func st_charge(delta) -> void:
	
	if %charge_timer.is_stopped():
		change_state(State.SHOT)

func shot() -> void:
	if WpRes.bullet_scene == null:
		return
	
	for a in range(WpRes.bullet_in_shot):
		
		#fire_rate_timer.wait_time = fire_rate
		#%vfx_shot_spark.lifetime = fire_rate
		
		var bullet:BaseBullet = WpRes.bullet_scene.instantiate()
		get_tree().current_scene.add_child(bullet)

		# Ставим пулю на дуло
		bullet.global_position = %bullet_marker.global_position

		# Считаем ВЕКТОР НАПРАВЛЕНИЯ от дула до точки прицеливания
		var direction: Vector3 = -weapon_cont.global_transform.basis.z
		#var sprad_dir := direction

		var spread_y := deg_to_rad(randf_range(-WpRes.spred, WpRes.spred))
		var spread_x := deg_to_rad(randf_range(-WpRes.spred, WpRes.spred))
		
		var sprad_dir := direction.rotated(basis.y, spread_y)	
		sprad_dir = sprad_dir.rotated(basis.x, spread_x)
		
		bullet.global_position = %bullet_marker.global_position
		bullet.set_start(WpRes.bullet_res,sprad_dir,WpRes.damage)

		WpRes.spred = clampf(WpRes.spred + WpRes.spred_pre_shot,WpRes.min_spred,WpRes.max_spred)

func weapon_aim(delta) -> void:
	target_node = null
	var target_point:Vector3

	if aim_area.has_overlapping_areas():
		target_node = get_closest_enemy_in_screen_circle(aim_area.get_overlapping_areas())



	if target_node:
		target_point = target_node.global_position
	else:
		target_point = global_position - (global_transform.basis.z * 10.0)
		# 1. Получаем вектор направления на цель локально (относительно пушки)
		# Это сбросит глобальные координаты и покажет, где цель относительно НАШЕГО центра
	var local_target_dir: Vector3 = to_local(target_point).normalized()

	# 2. Считаем поворот влево-вправо (вокруг оси Y)
	# atan2 работает как компас: смотрит на координаты X и Z и говорит точный угол
	var angle_y := atan2(-local_target_dir.x, -local_target_dir.z)

	# 3. Считаем поворот вверх-вниз (вокруг оси X)
	# Нам нужно узнать угол наклона относительно высоты (Y) и длины на плоскости
	var flat_distance := Vector2(local_target_dir.x, local_target_dir.z).length()
	var angle_x := atan2(local_target_dir.y, flat_distance)

	# 4. Применяем углы в ноду поворота
	weapon_cont.rotation.x = lerp_angle(weapon_cont.rotation.x,angle_x,delta * WpRes.aim_assist_power_mod)
	weapon_cont.rotation.y = lerp_angle(weapon_cont.rotation.y,angle_y,delta * WpRes.aim_assist_power_mod)
	weapon_cont.rotation.z = 0


func get_closest_enemy_in_screen_circle(enemy_area: Array) -> Node3D:
	if enemy_area.is_empty():
		return null
	
	var screen_center := get_viewport().get_visible_rect().size / 2
	var closest_enemy: Node3D = null
	var min_distance: float = 256.0
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
