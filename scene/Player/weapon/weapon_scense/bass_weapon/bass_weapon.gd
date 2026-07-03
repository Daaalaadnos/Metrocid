extends Node3D

class_name BassWeapon

enum State{IDLE,CHARGE,SHOT,RELOAD}
var state = State.IDLE
var nex_state = null

@onready var anim_player: AnimationPlayer = $AnimationPlayer

@onready var fire_rate_timer:Timer = get_node('%fire_rate_timer')

@onready var weapon_cont: Node3D = %container
@onready var sub_container: Node3D = %sub_container
@onready var vfx: WeaponVFXManager = $container/vfx


@export var WpRes:WeaponStats

var aim_assist:AimAsistManager

var target_node:Node3D

func _input(event: InputEvent) -> void:
	match state:
		State.IDLE:
			if event.is_action_pressed('shot'):
				change_state(State.SHOT)

func _ready() -> void:
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
			ch_idle()
		State.CHARGE:
			ch_charge()
		State.SHOT:
			ch_shot()
		State.RELOAD:
			ch_reload()
		
	state = nex_state
	nex_state = null

func ch_idle() -> void:
	anim_player.play('idle')
	vfx.idle()
	
func ch_charge() -> void:
	pass
func ch_shot() -> void:
	anim_player.play('shot')
	var rand_fire_rate = (randf_range(WpRes.fire_rate,WpRes.fire_rate * 1.3))
	fire_rate_timer.start(rand_fire_rate)
	shot()
	%shot_player.play()
	vfx.shot()

func ch_reload() -> void:
	pass



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	match state:
		State.IDLE:
			st_idle(delta)
		State.CHARGE:
			st_charge(delta)
		State.SHOT:
			st_shot(delta)
	
	weapon_aim(delta)
	
	WpRes.spred = clampf(WpRes.spred - delta * WpRes.spred_damp_mod,WpRes.min_spred,WpRes.max_spred)
	%Aim_point.update_scale_from_sprad(remap(WpRes.spred,WpRes.min_spred,WpRes.max_spred,0.2,1.5))
	
	aplly_change_state()

func st_idle(delta) -> void:
	pass


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
		add_bullet(%bullet_marker.global_position)

func add_bullet(pos:Vector3):
	var bullet:BaseBullet = WpRes.bullet_scene.instantiate()
	get_tree().current_scene.add_child(bullet)

	bullet.global_position = pos
	set_bullet_data(bullet)
	
func set_bullet_data(bullet:BaseBullet):
	bullet.set_start(spread_dir(),WpRes.damage,WpRes.bullet_speed,WpRes.bullet_vfx)

func spread_dir() -> Vector3:
			# Считаем ВЕКТОР НАПРАВЛЕНИЯ от дула до точки прицеливания
		var direction: Vector3 = -weapon_cont.global_transform.basis.z
		var spread_y := deg_to_rad(randf_range(-WpRes.spred, WpRes.spred))
		var spread_x := deg_to_rad(randf_range(-WpRes.spred, WpRes.spred))
		var sprad_direction := direction.rotated(weapon_cont.global_transform.basis.y, spread_y)
		var local_x = sprad_direction.cross(weapon_cont.global_transform.basis.y).normalized()
		sprad_direction = sprad_direction.rotated(local_x, spread_x)
		WpRes.spred = clampf(WpRes.spred + WpRes.spred_pre_shot,WpRes.min_spred,WpRes.max_spred)
		return sprad_direction

func weapon_aim(delta) -> void:
	if aim_assist == null:
		return
	target_node = null
	
	target_node = aim_assist.update_aim_assist()
	

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
	weapon_cont.rotation.x = lerp_angle(weapon_cont.rotation.x,angle_x,delta * WpRes.aim_assist_power_mod)
	weapon_cont.rotation.y = lerp_angle(weapon_cont.rotation.y,angle_y,delta * WpRes.aim_assist_power_mod)
	weapon_cont.rotation.z = 0
	
	
	
