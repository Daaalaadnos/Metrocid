extends CharacterBody3D

class_name BaseBullet

enum State{START,ATTACK,FREEZ,DEAD}
var state = State.START
var nex_state = null

@export var audion_pl_cont:Node3D

var bullet_res:BulletPatam
var bullet_visual:BulletVfx

const LAYER_WORLD  = 1 << 0
const LAYER_PLAYER = 1 << 1
const LAYER_ENEMY  = 1 << 2

@export var SPEED = 15.0


var direction:Vector3

var damage:int 

func change_state(new_state:State) -> void:	
	if nex_state != null and new_state < nex_state:
		return

	nex_state = new_state

func apply_change_state() -> void:
	if nex_state == null:
		return
	match nex_state:
		State.START:
			start()
		State.ATTACK:
			attack()
		State.FREEZ:
			freez()
		State.DEAD:
			dead()
	state = nex_state
	nex_state = null

func set_start(new_res:BulletPatam,new_dir:Vector3,new_damage:int = 1,is_enemy_bullet:bool = false) -> void:
	bullet_res = new_res
	SPEED = bullet_res.speed
	add_visual()
	if is_enemy_bullet:
		collision_mask = LAYER_WORLD | LAYER_PLAYER
	else:
		collision_mask = LAYER_WORLD | LAYER_ENEMY
	direction = new_dir
	damage = new_damage
	change_state(State.ATTACK)

func add_visual() -> void:
	if bullet_res == null and bullet_res.visual_part_scene == null:
		return
	
	bullet_visual = bullet_res.visual_part_scene.instantiate()
	add_child(bullet_visual)

func start() -> void:
	pass

func attack() -> void:
	velocity = direction * SPEED

func freez() -> void:
	pass

func dead() -> void:
	velocity = Vector3.ZERO
	
	bullet_visual.dead()
	await get_tree().create_timer(1.0).timeout
	call_deferred('queue_free')

func _process(delta: float) -> void:
	match state:
		State.START:
			st_start(delta)
		State.ATTACK:
			st_attack(delta)
		State.FREEZ:
			st_freez(delta)
		State.DEAD:
			st_dead(delta)

func _physics_process(delta: float) -> void:
	match state:
		State.START:
			st_ph_start(delta)
		State.ATTACK:
			st_ph_attack(delta)
		State.FREEZ:
			st_ph_freez(delta)
		State.DEAD:
			st_ph_dead(delta)


	apply_change_state()


func st_start(delta) -> void:
	pass

func st_ph_start(delta) -> void:
	pass

func  st_attack(delta) -> void:
	pass

func  st_ph_attack(delta) -> void:
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

func  st_freez(delta) -> void:
	pass

func  st_ph_freez(delta) -> void:
	pass

func  st_dead(delta) -> void:
	pass

func  st_ph_dead(delta) -> void:
	pass

func make_damage(target) -> void:
	if !is_instance_valid(target):
		return
	
	if target.has_method('get_damage'):
		target.get_damage(damage)


func aim_assist(delta:float,target_node:Node3D) -> void:
	var target_point:Vector3
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
	rotation.x = lerp_angle(rotation.x,angle_x,delta * bullet_res.aim_assist_power_mod)
	rotation.y = lerp_angle(rotation.y,angle_y,delta * bullet_res.aim_assist_power_mod)
	rotation.z = 0


func _on_life_time_timeout() -> void:
	if state != State.DEAD:
		change_state(State.DEAD)
