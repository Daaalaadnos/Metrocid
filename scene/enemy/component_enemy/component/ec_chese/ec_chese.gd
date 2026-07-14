extends EC_Base


enum State {DREAM, CHESE}
var state: State

@export var min_dist:float = 5.0

func _physics_process(delta: float) -> void:
	if player == null: return
	
	if not enemy.is_on_floor():
		enemy.velocity += enemy.get_gravity() * delta
	
	match state:
		State.DREAM:
			if enemy.player_in_attack_area:
				state = State.CHESE
			enemy.velocity = Vector3.ZERO
			
		State.CHESE:
			var target_point: Vector3
			if !enemy.player_in_attack_area:
				if enemy.global_position.distance_to(enemy.start_pos) <= 2.0:
					state = State.DREAM
					return
				target_point = enemy.start_pos
			else:
				target_point = player.global_position
			
			if enemy.global_position.distance_to(player.global_position) <= min_dist:
				enemy.velocity.x = lerp(enemy.velocity.x, 0.0, delta * 5.0)
				enemy.velocity.z = lerp(enemy.velocity.z, 0.0, delta * 5.0)
				return

			# Наземный смотрит ровно перед собой
			var look_target = target_point
			look_target.y = enemy.global_position.y
			if enemy.global_position.distance_to(look_target) > 0.1:
				enemy.look_at(look_target, Vector3.UP)
			
			var direction = enemy.global_position.direction_to(target_point)
			
			
			if direction:
				enemy.velocity.x = lerp(enemy.velocity.x, direction.x * enemy_res.SPEED, delta * 5.0)
				enemy.velocity.z = lerp(enemy.velocity.z, direction.z * enemy_res.SPEED, delta * 5.0)
			else:
				enemy.velocity.x = lerp(enemy.velocity.x, 0.0, delta * 5.0)
				enemy.velocity.z = lerp(enemy.velocity.z, 0.0, delta * 5.0)
