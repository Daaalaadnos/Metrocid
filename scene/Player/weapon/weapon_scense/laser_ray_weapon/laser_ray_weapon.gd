extends BassWeapon
@onready var ray_mash: MeshInstance3D = $container/sub_container/ray_mash
@onready var attack_kast: ShapeCast3D = $container/sub_container/attack_kast

@export var is_piercing:bool = false

func _ready() -> void:
	super._ready()
	ray_mash.visible = false

func ch_idle() -> void:
	super.ch_idle()
	ray_mash.visible = false

func ch_shot() -> void:
	super.ch_shot()
	ray_mash.visible = true

func st_shot(delta):
	if !Input.is_action_pressed('shot'):
		ray_mash.visible = false
		change_state(State.IDLE)
	
	if attack_kast.is_colliding() and fire_rate_timer.is_stopped():
		fire_rate_timer.start()
		
		var nearest_enemy: Enemy = null
		var min_dist: float = INF
		
		for i in attack_kast.get_collision_count():
			var collider = attack_kast.get_collider(i)
			
			if collider is Enemy:
				if is_piercing:
					# Если пробой включен — наносим урон СРАЗУ ВСЕМ по цепочке
					collider.get_damage(WpRes.damage)
				else:
					# Если пробоя нет — просто ищем одного ближайшего
					var dist_to_target = global_position.distance_to(collider.global_position)
					if dist_to_target < min_dist: # ИСПРАВЛЕНО: ищем меньшее расстояние
						min_dist = dist_to_target
						nearest_enemy = collider

		# Если пробоя не было, но мы нашли кого-то одного ближайшего — бьем его
		if not is_piercing and nearest_enemy != null:
			nearest_enemy.get_damage(WpRes.damage)
	
	sub_container.transform = anim_container.transform
	#var spred:Vector3 = spread_dir()
	#sub_container.look_at(global_position + spred * 1000)
	
