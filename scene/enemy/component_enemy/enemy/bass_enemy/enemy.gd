extends CharacterBody3D

class_name Enemy

signal sg_enemy_dead
@onready var player_detected_area: Area3D = %player_detected_area
@onready var body_cont: Node3D = $body_cont

enum State{DREAM,ACTIVE,STAN,DEAD}
var state = State.DREAM
var nex_state = null

@export var enemy_res:EnemyRes
@export var bullet_res:BulletStats

@export var speed:float = 5.0
var direction:Vector3

var HP:float

var is_dead:bool = false

var player:Player
var player_in_attack_area:bool = false

var start_pos:Vector3

func _ready() -> void:

	if GlobalData.player != null:
		_on_player_ready(GlobalData.player)
	else:
		SignalHub.player_initialized.connect(_on_player_ready)

	enemy_res = enemy_res.duplicate()
	HP = enemy_res.HP
	await get_tree().process_frame
	start_pos = global_position

func change_state(new_state:State) -> void:	
	if nex_state != null and new_state < nex_state:
		return
	nex_state = new_state

func apply_change_state() -> void:
	if nex_state == null:
		return
	match nex_state:
		State.DREAM:
			ch_dream()
		State.ACTIVE:
			ch_active()
		State.STAN:
			ch_stan()
		State.DEAD:
			ch_dead()
		
	state = nex_state
	nex_state = null

func ch_dream() -> void:
	pass

func ch_active() -> void:
	pass

func  ch_stan() -> void:
	pass

func  ch_dead() -> void:
	
	call_deferred('queue_free')


func _process(delta: float) -> void:
	match state:
		State.DREAM:
			st_dream(delta)
		State.ACTIVE:
			st_active(delta)
		State.STAN:
			st_stan(delta)
		State.DEAD:
			st_dead(delta)
	

func _physics_process(delta: float) -> void:
	
	match state:
		State.DREAM:
			st_ph_dream(delta)
		State.ACTIVE:
			st_ph_active(delta)
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

func st_active(delta):
	pass

func st_ph_active(delta):
	pass

func st_stan(delta):
	pass

func st_ph_stan(delta):
	pass

func st_dead(delta):
	pass

func st_ph_dead(delta):
	pass

func get_damage(damage:float) -> void:
	HP -= damage
	body_cont.take_damage_flash()
	if HP <= 0:
		dead()

func dead() -> void:
	change_state(State.DEAD)

func _on_player_ready(player_ref: CharacterBody3D) -> void:
	player = player_ref

	if SignalHub.player_initialized.is_connected(_on_player_ready):
		SignalHub.player_initialized.disconnect(_on_player_ready)
		
	print("Враг ", name, " успешно нашел игрока!")


func pl_status_update(new_status:bool = false) -> void:
	player_in_attack_area = new_status

func _on_player_detected_area_body_exited(body: Node3D) -> void:
	if body is Player:
		player_in_attack_area = false
