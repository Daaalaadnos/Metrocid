extends Enemy

@onready var shot: EC_Base = $shot

@onready var move_manager: Node = $move_manager
@onready var jump: EC_Base = $jump

@onready var move_timer: Timer = %move_timer
@onready var fire_rate: Timer = $timers/fire_rate
@onready var chain_jump_timer: Timer = $timers/chain_jamp_timer

@onready var hp_bar: ProgressBar = %hp_bar
@onready var stamima_bar: ProgressBar = %stamima_bar

#@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var max_stamina:int = 200
var stamina:float = 0



@export var start_colon:Node3D


@export var jump_curve: Curve

@export_category('colon_cont')
@export var center_colon_cont:Node3D
@export var midl_colon_cont:Node3D
@export var far_colon_cont:Node3D

@export_category('Attake')
@export var attack_list:Array[ColoneBossAttack]
var next_attack:ColoneBossAttack
@export var level:int = 0
var pull_bullets:int 


var last_colon:Array[Node3D]

var current_move:ColoneBossAttack
var move_time:float = 1.0

var max_chain_jump:int = 3



var move_weights:Dictionary = {
	#"jump": 30,
	#'graned_shot_in_jump':70
	#'chain_jump':15,
	'shot_from_colone':100
	#"jump_shoot": 40,
	#"spawn_minions": 15,
	#"kamikaze_drop": 15
}

var nex_attack:Node3D

func _ready() -> void:
	super._ready()
	hp_bar.visible = false
	
	hp_bar.max_value = enemy_res.HP
	hp_bar.value = enemy_res.HP
	
	stamina = max_stamina
	
	stamima_bar.visible = false
	stamima_bar.max_value = max_stamina
	stamima_bar.value = stamina
	
	jump.jump_in_midl_pos.connect(fire_in_jump)

func st_dream(delta):
	if player_in_attack_area:
		change_state(State.ACTIVE)
		hp_bar.visible = true
		stamima_bar.visible = true

func choose_next_move() -> void:
	current_move = move_manager.choose_next_move_by_weights()
	#print('next_move - ', current_move.attack_name)
	
	var colone_cont:Node3D = get_tree().current_scene.get_node(current_move.colone_marker)
	if current_move.can_jump:
		jump.start_custom_jump(
			chose_nex_colone(colone_cont),
			current_move.move_time * current_move.jump_time_mod,
			)

	move_timer.start(current_move.move_time)

func st_active(delta):
	if move_timer.is_stopped():
		choose_next_move()
		return
	
	#if current_move.can_jump and jump.is_jumping:
		#return
	if current_move.can_shot and fire_rate.is_stopped():
		fire_rate.start(current_move.fire_rait)
		pull_bullets = current_move.bullet_in_shot

	if pull_bullets > 0:
		for i in 1:
			shot.shot()
			pull_bullets -= 1

		#'shot_from_colone':
			#trans_to_pause_betwen_moves()
			#if !jump.is_jumping:
				#if fire_rate.is_stopped():
					#fire_rate.start(0.5)
					#pull_bullets = 10
				#if pull_bullets > 0:
					#for i in 1:
						#shot.shot(next_attack.bullet_scene,get_node(next_attack.marker))
					#pull_bullets -= 1
#
					#stamina -= 1
				##animation_player.play('rest')




	#for attack in attack_list:
		#if attack.attack_name == current_move:
			#next_attack = attack
	
	##print('new move - ',current_move)
	#match new_move:
		#'pause':
			#pass
			##animation_player.play('preper')
		#
		#'jump':
			#move_time = 2.0
			#jump.start_custom_jump(
				#chose_nex_colone([midl_colon_cont].pick_random()),
				#move_time,
				#)
			##animation_player.play('jump')
		#'graned_shot_in_jump':
			#move_time = 2.0
			#jump.start_custom_jump(
				#chose_nex_colone([far_colon_cont].pick_random()),
				#move_time,
				#)
		#'shot_from_colone':
			#move_time = 5.0
			#jump.start_custom_jump(
				#chose_nex_colone([center_colon_cont].pick_random()),
				#1.0,
				#)
			#pull_bullets = 60
			##animation_player.play('jump')
		#'chain_jump':
			#move_time = 3.0
			#chain_jump_timer.stop()
			##animation_player.play('jump')
		#'rest':
			#move_time = 10.0
			#jump.start_custom_jump(
				#chose_nex_colone([center_colon_cont].pick_random()),
				#1.0,
				#)
			##animation_player.play('rest')
#
	#move_timer.start(move_time)
	#stamima_bar.value = stamina
#
#func st_active(delta):
	#match current_move:
		#'pause', '':
			#if move_timer.is_stopped():
				#choose_next_move(move_manager.choose_next_move_by_weights())
				#
		#'jump':
			#trans_to_pause_betwen_moves()
		#
		#'shot_from_colone':
			#trans_to_pause_betwen_moves()
			#if !jump.is_jumping:
				#if fire_rate.is_stopped():
					#fire_rate.start(0.5)
					#pull_bullets = 10
				#if pull_bullets > 0:
					#for i in 1:
						#shot.shot(next_attack.bullet_scene,get_node(next_attack.marker))
					#pull_bullets -= 1
#
					#stamina -= 1
				##animation_player.play('rest')
		#'graned_shot_in_jump':
			#trans_to_pause_betwen_moves()
			#if pull_bullets > 0:
				#for i in 10:
					#shot.shot(next_attack.bullet_scene,get_node(next_attack.marker))
				#pull_bullets -= 10
#
		#
		#'chain_jump':
			#trans_to_pause_betwen_moves(4.0)
			#if chain_jump_timer.is_stopped():
				#chain_jump_timer.start(move_time/max_chain_jump)
				#jump.start_custom_jump(
					#chose_nex_colone([midl_colon_cont,far_colon_cont].pick_random()),
					#move_time/max_chain_jump,
					#)
				#stamina -= move_weights['chain_jump']
		#'rest':
			#if stamina >= max_stamina and move_timer.is_stopped():
				#choose_next_move('jump')
#
			#stamina = clampf(stamina + delta * 10.0 ,0,max_stamina)
	#
	#look_at(player.global_position,Vector3.UP)
#
#func trans_to_pause_betwen_moves(pause_time:float = 3.0) -> void:
	#if move_timer.is_stopped():
		#choose_next_move('pause')
		#move_timer.start(pause_time)

func chose_nex_colone(colon_cont:Node3D) -> Marker3D:
	if last_colon.size() >= 3:
		last_colon.erase(last_colon[0])

	var list = colon_cont.get_children()
	
	for l_colon in last_colon:
		list.erase(l_colon)
	
	if list.size() <= 0:
		push_error(colon_cont,'- is empty')
		return start_colon.get_node('Marker3D')
	
	var colon:Node3D = list.pick_random()
	last_colon.append(colon)
	return colon.get_node('Marker3D')



func get_damage(damage:float) -> void:
	super.get_damage(damage)
	hp_bar.value -= damage

func fire_in_jump() -> void:
	pull_bullets = current_move.bullet_pull
