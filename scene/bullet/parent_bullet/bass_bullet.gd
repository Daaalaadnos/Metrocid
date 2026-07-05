extends CharacterBody3D

class_name BaseBullet

enum State{START,ATTACK,FREEZ,DEAD}
var state = State.START
var nex_state = null

var res:BulletStats

@onready var life_timer: Timer = $timers/life_timer

@export var audion_pl_cont:Node3D

var target:Node3D = null

var bullet_visual_scene:BulletVfx

const LAYER_WORLD  = 1 << 0
const LAYER_PLAYER = 1 << 1
const LAYER_ENEMY  = 1 << 2

@export var SPEED = 15.0


var direction:Vector3

var damage:int 

func _ready() -> void:
	life_timer.start()

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

#func set_start(new_dir:Vector3,new_damage:int = 1,new_speed:float = 10.0,new_vfx:PackedScene = null,is_enemy_bullet:bool = false) -> void:
func set_start(new_dir:Vector3,new_res:BulletStats,new_target:Node3D,is_enemy_bullet:bool = false) -> void:
	res = new_res
	
	if res.visual_part_scene == null:
		push_warning('bullet_vfx_scene == null')
		call_deferred('queue_free')
		return

	target = new_target
	direction = new_dir
	damage = res.damage
	SPEED = res.speed

	if is_enemy_bullet:
		collision_mask = LAYER_WORLD | LAYER_PLAYER
	else:
		collision_mask = LAYER_WORLD | LAYER_ENEMY

	add_visual(res.visual_part_scene)
	change_state(State.ATTACK)

func add_visual(vfx_scene:PackedScene = null) -> void:
	bullet_visual_scene = vfx_scene.instantiate()
	add_child(bullet_visual_scene)

func start() -> void:
	pass

func attack() -> void:
	velocity = direction * SPEED

func freez() -> void:
	pass

func dead() -> void:
	velocity = Vector3.ZERO
	
	bullet_visual_scene.dead()
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
	pass

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


func _on_life_timer_timeout() -> void:
	if state != State.DEAD:
		change_state(State.DEAD)
