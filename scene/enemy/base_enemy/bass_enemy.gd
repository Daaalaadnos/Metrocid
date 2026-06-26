extends CharacterBody3D

class_name BaseEnemyClass

enum State{DREAM,MOVE,ATTACK,STAN,DEAD}
var state = State.DREAM
var nex_state = null

@export var enemy_res:EnemyRes
@export var bullet_res:BulletPatam

@onready var body_cont:Node3D = get_node('%body_cont')
@onready var fire_rate_timer:Timer = get_node('%fire_rate_timer')

var HP:int = 10

var bullet_start_markers_area:Array

var direction:Vector3

var is_dead:bool = false

var player:Player
var player_in_attack_area:bool = false

func _ready() -> void:

	if GlobalData.player != null:
		_on_player_ready(GlobalData.player)
	else:
		SignalHub.player_initialized.connect(_on_player_ready)


	HP = enemy_res.HP
	bullet_start_markers_area = %bullet_start_cont.get_children()
	

func change_state(new_state:State) -> void:	
	if nex_state != null and new_state < nex_state:
		return

	nex_state = new_state

func apply_change_state() -> void:
	if nex_state == null:
		return
	match nex_state:
		State.DREAM:
			dream()
		State.MOVE:
			move()
		State.ATTACK:
			attack()
		State.STAN:
			stan()
		State.DEAD:
			dead()
		
	state = nex_state
	nex_state = null

func dream() -> void:
	pass

func  move() -> void:
	pass

func  attack() -> void:
	pass

func  stan() -> void:
	pass

func  dead() -> void:
	pass


func _process(delta: float) -> void:
	
	match state:
		State.DREAM:
			st_dream(delta)
		State.MOVE:
			st_move(delta)
		State.ATTACK:
			st_attack(delta)
		State.STAN:
			st_stan(delta)
		State.DEAD:
			st_dead(delta)
	

func _physics_process(delta: float) -> void:
	
	match state:
		State.DREAM:
			st_ph_dream(delta)
		State.MOVE:
			st_ph_move(delta)
		State.ATTACK:
			st_ph_attack(delta)
		State.STAN:
			st_ph_stan(delta)
		State.DEAD:
			st_ph_dead(delta)

	apply_change_state()
	move_and_slide()

func st_dream(delta):
	pass

func st_ph_dream(delta):
	pass

func st_move(delta):
	pass

func st_ph_move(delta):
	pass

func st_attack(delta):
	pass

func st_ph_attack(delta):
	pass

func st_stan(delta):
	pass

func st_ph_stan(delta):
	pass

func st_dead(delta):
	pass

func st_ph_dead(delta):
	pass

func shot() -> void:
	if enemy_res.bullet_scene == null:
		return
	
	if bullet_start_markers_area.size() <= 0:
		push_error('bullet_marker_arrea = null')
		return
	
	for bullet_marker in bullet_start_markers_area:
		await get_tree().create_timer(randf_range(0.05,0.1)).timeout
	
		for a in range(enemy_res.bullet_in_shot):
			
			%fire_player.play()
			#fire_rate_timer.wait_time = fire_rate
			#%vfx_shot_spark.lifetime = fire_rate
			
			var bullet:BaseBullet = enemy_res.bullet_scene.instantiate()
			get_tree().current_scene.add_child(bullet)

			# Ставим пулю на дуло
			bullet.global_position = bullet_marker.global_position

			# Считаем ВЕКТОР НАПРАВЛЕНИЯ от дула до точки прицеливания
			var target_point:Vector3
			target_point = GlobalData.player.global_position + Vector3.UP if is_instance_valid(GlobalData.player) else global_transform.basis.z
			
			var direction: Vector3 = global_position.direction_to(target_point)
			var sprad_dir := direction
			sprad_dir = sprad_dir.rotated(Vector3.UP, deg_to_rad(randf_range(-enemy_res.spred_power,enemy_res.spred_power)))
			sprad_dir = sprad_dir.rotated(Vector3.RIGHT, deg_to_rad(randf_range(-enemy_res.spred_power,enemy_res.spred_power)))
			bullet.set_start(enemy_res.bullet_res,sprad_dir,enemy_res.damage,true)
			#bullet.SPEED = 25
			bullet.scale *= 3

func player_is_see() -> bool:
	
	var space := get_world_3d().direct_space_state
		
	# 2. Проверка видимости (Raycast) только для тех, кто прошел первый фильтр
	var query := PhysicsRayQueryParameters3D.create(global_position, player.global_position)
	query.collision_mask = (1 << 0) | (1 << 1)
	# query.exclude = [self] # Можно добавить исключение себя, если нужно
	
	var result := space.intersect_ray(query)
	if result:
		# Если луч встретил что-то, что не является этим врагом (или его владельцем) — значит враг за стеной
		if result.collider == player and result.collider != self:
			return true
	return false

func get_damage(damage) -> void:
	player_in_attack_area = true
	HP -= damage
	if HP <= 0:
		change_state(State.DEAD)
	%take_hit_player.play()


func _on_dead_timer_timeout() -> void:
	call_deferred('queue_free')

func _on_player_ready(player_ref: CharacterBody3D) -> void:
	player = player_ref

	if SignalHub.player_initialized.is_connected(_on_player_ready):
		SignalHub.player_initialized.disconnect(_on_player_ready)
		
	print("Враг ", name, " успешно нашел игрока!")


func pl_status_update(new_status:bool = false) -> void:
	player_in_attack_area = new_status

func _on_player_detected_area_body_entered(body: Node3D) -> void:
	pl_status_update(true)

func _on_player_detected_area_body_exited(body: Node3D) -> void:
	pl_status_update(false)
