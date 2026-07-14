extends Node3D

class_name Bullet

@onready var shot_cast: RayCast3D = $ray_cast/RayCast3D

@export var speed:float = 30.0
@export var damage:float = 10.0

var WPres:WeaponStats

var direction:Vector3

var is_enemy:bool = false
const LAYER_WORLD  = 1 << 0
const LAYER_PLAYER = 1 << 1
const LAYER_ENEMY  = 1 << 2

var is_dead:bool = false

@export_category('bounce')
@export var is_bouncing:bool = false
@export var max_bounce:int = 3
var bounce:int = 0

@export_category('pierc')
@export var is_piercing:bool = false
@export var max_piercing:int = 5
var piercing:int

@export_category('aim_to_target')
@export var is_aiming:bool = false
@export var aim_speed_mod:float = 2.0
var target_node:Node3D

@export_category('separation')
@export var is_separation:bool = false
@export var max_separation:int = 5
var separation:int

func set_start(new_dir:Vector3,new_res:WeaponStats,new_target:Node3D = null,is_enemy_bullet:bool = false) -> void:
	direction = new_dir
	look_at(direction)
	WPres = new_res
	speed = WPres.bullet_speed
	set_collision(is_enemy_bullet)
	is_enemy = is_enemy_bullet


func set_collision(is_enemy_bullet:bool) -> void:
	if is_enemy_bullet:
		shot_cast.collision_mask = LAYER_WORLD | LAYER_PLAYER
	else:
		shot_cast.collision_mask = LAYER_WORLD | LAYER_ENEMY

func _physics_process(delta: float) -> void:
	if is_dead:
		return
	
	if direction == Vector3.ZERO:
		return
	
	update_aiming(delta)
	
	var frame_dist = speed * delta 
	shot_cast.target_position =Vector3(0,0, -(frame_dist * 1.1))
	shot_cast.force_raycast_update()
	
	if shot_cast.is_colliding():
		
		var collider = shot_cast.get_collider()
		if collider is Player:
			SignalHub.emit_signal('playr_make_damage',damage)
			update_piercing()
		elif collider is Enemy:
			make_damage(collider)
			update_piercing()
		else:
			update_bounce()
			update_separation()

		dead()
	else:
		global_position += direction * frame_dist

func update_separation() -> void:
	if is_separation:
		var dir_z:Vector3 = global_transform.basis.z
		for i in max_separation:
			var bullet:Bullet = WPres.bullet_scene.instantiate(PackedScene.GEN_EDIT_STATE_DISABLED)
			get_tree().current_scene.add_child(bullet)
			var new_dir = Vector3.RIGHT.rotated(dir_z,deg_to_rad((360 / max_separation) * i))
			
			bullet.set_start(new_dir,WPres,target_node,is_enemy)
			bullet.is_separation = false
			bullet.global_position = shot_cast.get_collision_point()
	is_separation = false

func update_bounce() -> void:
	if is_bouncing:
		bounce += 1
		direction = direction.bounce(shot_cast.get_collision_normal()).normalized()
		if bounce >= max_bounce:
			is_bouncing = false

func update_piercing() -> void:
	if is_piercing:
		piercing += 1
		if piercing >= max_piercing:
			is_piercing = false

func update_aiming(delta) -> void:
	if !is_aiming:return

	if !is_instance_valid(target_node):return

	direction = direction.lerp(global_position.direction_to(target_node.global_position),delta * aim_speed_mod)


func make_damage(target) -> void:
	if !is_instance_valid(target):
		return
	
	if target.has_method('get_damage'):
		target.get_damage(damage)

func dead() -> void:
	if is_bouncing or is_piercing or is_separation:
		return
	
	set_physics_process(false)
	is_dead = true
	$MeshInstance3D2.visible = false
	for child in $vfx.get_children():
		if child is GPUParticles3D:
			child.restart()
	await get_tree().create_timer(2.0).timeout
	call_deferred('queue_free')

func _on_life_timer_timeout() -> void:
	dead()
