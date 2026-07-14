extends EC_Base

@export var explosion_scene:PackedScene
@export var damage:float = 30.0
@export var exp_scale:float = 1.0

@export var area:Area3D

@export var is_work:bool = true

func _ready() -> void:
	if area:
		area.body_entered.connect(explosion)
	enemy.sg_enemy_dead.connect(self_explosion)

func _process(delta: float) -> void:
	
	if enemy.HP <= 0:
		self_explosion()
	
func self_explosion():
	is_work = true
	explosion()

func explosion(body:CharacterBody3D = null) -> void:
	if !is_work:
		return
	
	if explosion_scene == null:
		enemy.call_deferred('queue_free')
		push_error(enemy.name,'- explosion_scene is null ')

	var exp = explosion_scene.instantiate()
	get_tree().current_scene.add_child(exp)
	exp.global_position = enemy.global_position
	exp.start(exp_scale,damage)
	await get_tree().create_timer(0.2).timeout
	enemy.call_deferred('queue_free')
