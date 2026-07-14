extends CharacterBody3D

class_name  TestEnemy

@export var HP:int = 100

@export var dash_power:float = 5.0
@export var damp_mod:float = 3.0

@export var bullet_scene:PackedScene
@export var bullet_in_shot:int = 1
@export var spred_power:float = 2.0
@export var damage:int = 10
@export var fire_rite:float = 1.0

var player_in_attack_area:bool = false

var direction:Vector3

var dir_to_start_pos:Vector3
var start_pos:Vector3

var is_dead:bool = false

func _ready() -> void:
	start_pos = global_position
	dir_to_start_pos = Vector3.RIGHT

func _process(delta: float) -> void:
	
	if player_in_attack_area:
		if $fire_rate.is_stopped() and !is_dead:
			$fire_rate.start(fire_rite)
			shot()
		


func _physics_process(delta: float) -> void:

	velocity.move_toward(Vector3.ZERO, delta * damp_mod)
	
	move_and_slide()

func get_damage(damage) -> void:
	HP -= damage
	if HP <= 0:
		dead()
		return
	%take_hit.play()
	under_fire()
	
	
func under_fire() -> void:
	if is_dead:
		return

	#if randf() > 0.2:
		#return
	
	var rand_dir := Vector3(randf(),randf(),randf())
	var rand_pos := start_pos + rand_dir * dash_power
	#look_at_from_position(rand_pos,player.global_transform.origin)

	var tween := create_tween()
	tween.tween_property(self, "global_position", rand_pos, 0.5).set_trans(Tween.TRANS_EXPO)

func dead() -> void:
	$body_cont.hide()
	%dead.play()
	is_dead = true
	for vfx in $vfx.get_children():
		if vfx is GPUParticles3D:
			vfx.emitting = true
	collision_layer = 0
	$Area3D.monitorable = false
	await get_tree().create_timer(5.0).timeout
	call_deferred('queue_free')

func shot() -> void:
	if bullet_scene == null:
		return
	
	for a in range(bullet_in_shot):
		
		#fire_rate_timer.wait_time = fire_rate
		#%vfx_shot_spark.lifetime = fire_rate
		
		var bullet:BaseBullet = bullet_scene.instantiate()
		get_tree().current_scene.add_child(bullet)

		# Ставим пулю на дуло
		bullet.global_position = global_position

		# Считаем ВЕКТОР НАПРАВЛЕНИЯ от дула до точки прицеливания
		var target_point:Vector3
		target_point = GlobalData.player.global_position if is_instance_valid(GlobalData.player) else global_transform.basis.z
		
		var direction: Vector3 = global_position.direction_to(target_point)
		var sprad_dir := direction
		sprad_dir = sprad_dir.rotated(Vector3.UP, deg_to_rad(randf_range(-spred_power,spred_power)))
		sprad_dir = sprad_dir.rotated(Vector3.RIGHT, deg_to_rad(randf_range(-spred_power,spred_power)))
		#bullet.set_start(sprad_dir,damage,true)
		bullet.SPEED = 25
		bullet.scale *= 3


@export var max_dist:float = 15
@export var min_dist:float = 7

func desh_around_target() ->void:
	
	pass


func _on_area_3d_2_body_entered(body: Node3D) -> void:
	player_in_attack_area = true


func _on_area_3d_2_body_exited(body: Node3D) -> void:
	player_in_attack_area = false
