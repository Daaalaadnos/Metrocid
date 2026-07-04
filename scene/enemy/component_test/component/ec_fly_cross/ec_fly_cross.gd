extends EC_Base
# Для летунов

enum State {DREAM, CHESE}
var state: State

@export var target_height: float = 4.0
@onready var ground_cast: RayCast3D = %ground_cast
@onready var wall_cast: RayCast3D = %wall_cast

var cross_dir:int = 1

func _physics_process(delta: float) -> void:
	if player == null: return
	
	wall_cast_update()
	
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
				# Твоя крутая логика дистанции
				var dist = enemy.global_position.distance_to(player.global_position)
				if dist > 12.0:
					target_point = player.global_position
				elif dist < 8.0:
					# Корректный отлёт назад: позиция врага в обратную сторону от игрока
					target_point = enemy.global_position + (player.global_position.direction_to(enemy.global_position) * 5.0)
				else:
					# Стрейф вбок (умножать на 50 не надо, 5-8 метров за глаза)
					target_point = player.global_position + ((enemy.global_transform.basis.x * cross_dir) * 6.0)
			
			# КОРРЕКТИРОВКА ВЫСОТЫ ПО РЕЙКАСТУ
			if ground_cast and ground_cast.is_colliding():
				var current_ground_y = ground_cast.get_collision_point().y
				target_point.y = current_ground_y + target_height
			else:
				# Если пола не видно, держим высоту игрока
				target_point.y = player.global_position.y + 1.0

			# Летун всегда смотрит ЧЁТКО на игрока, даже если стрейфит вбок!
			enemy.look_at(player.global_position, Vector3.UP)
			
			var direction = enemy.global_position.direction_to(target_point)
			enemy.velocity = lerp(enemy.velocity, direction * enemy_res.SPEED, delta * 2.0)

func wall_cast_update() -> void:
	wall_cast.target_position = -(enemy.velocity).normalized() * target_height
	if wall_cast.is_colliding():
		cross_dir *= -1
		
