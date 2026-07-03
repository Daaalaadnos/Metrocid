extends BaseEnemyClass

@onready var desh_timer:Timer = get_node('%desh_timer')
@onready var raycast:RayCast3D = get_node('%obstacles_cast')

@export var dash_max_dist_to_pl:float = 12.0
@export var dash_min_dist_to_pl:float = 8.0

var dist_to_pl:float

func _ready() -> void:
	super._ready()
	%desh_timer.start()

func dead() -> void:
	super.dead()
	$CollisionShape3D.scale *= 0.2
	collision_layer = 0
	
	%dead_player.play()
	#collision_mask = 0 << 1
	
	for child in %body_cont.get_children():
		child.visible = false
	
	var a:= %body_cont.get_children()[0]
	a.visible = true
	tween_tansparant(a)
	
	for child in %dead_vfx.get_children():
		if child is GPUParticles3D:
			child.emitting = true
	
	for child in  %hit_zone_area_cont.get_children():
		if child is Area3D:
			child.monitorable = false

func st_dream(delta):
	if player_in_attack_area:
		change_state(State.ATTACK)
	

	var strafe_dir = direction.cross(Vector3.UP).normalized()
	

func st_attack(delta):
	if !player_in_attack_area:
		change_state(State.DREAM)
	
	
	#else:
		#if global_position.distance_to(player.global_position) >= 200.0:
			#player_in_attack_area = false
	
	if desh_timer.is_stopped():
		desh_timer.start(randf_range(enemy_res.dead_time,enemy_res.dead_time + 1.0))
		desh(player.global_position)
	
	if fire_rate_timer.is_stopped():
		fire_rate_timer.start(randf_range(enemy_res.fire_rite,enemy_res.fire_rite + 0.5))
		if player_is_see():
			shot()

	body_cont.look_at(player.global_position)

func st_dead(delta):
	
	if !is_on_floor():
		velocity += get_gravity() * delta


func desh(target_:Vector3) -> void:
	
	%desh_player.play()
	%desh_stop.start()
	direction = global_position.direction_to(target_ - Vector3(0,2.5,0))
	dist_to_pl = (global_position * Vector3(1,0,1)).distance_to(target_ * Vector3(1,0,1))
	
	
	var target_point:Vector3
	if dist_to_pl < dash_min_dist_to_pl or dist_to_pl > dash_max_dist_to_pl:
		var pos_player := target_
		var pos_mob := global_position
		
		var dir_flat := Vector3(pos_player.x - pos_mob.x, 0, pos_player.z - pos_mob.z).normalized()
		
		target_point = pos_player - (dir_flat * dash_min_dist_to_pl)

	else:
		var back_dir := Vector3(global_position.x - target_.x, 0, global_position.z - target_.z).normalized()

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
	raycast.global_position = global_position
	raycast.target_position = raycast.to_local(target_position)
	
	raycast.force_raycast_update()
	
	if raycast.is_colliding():
		# Если впереди стена, берем точку удара
		var hit_point = raycast.get_collision_point()
		if global_position.distance_to(hit_point) <= 2.0:
			return global_position
		# И отступаем от нее назад к мобу на 1.5 метра, чтобы не застрять в текстуре
		var safe_direction = hit_point.direction_to(global_position)
		return hit_point + safe_direction * 1.5
	
	# Если стен нет, спокойно летим в изначально задуманную точку
	return target_position

func tween_tansparant(target_node:Node3D) -> void:

	var tween := create_tween()
	
	tween.set_trans(Tween.TRANS_BOUNCE)

	tween.tween_property(target_node,'transparency',0.8,1.5)

func tween_move(target_point:Vector3) -> void:

	var tween := create_tween()
	
	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_ease(Tween.EASE_OUT)
	
	tween.tween_property(self,'global_position',target_point,0.5)
	tween.finished.connect(func():
			pass
			velocity = Vector3.ZERO # Сбрасываем скорость после остановки
	)


func _on_desh_stop_timeout() -> void:
	velocity = Vector3.ZERO
