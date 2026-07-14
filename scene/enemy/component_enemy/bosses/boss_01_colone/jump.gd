extends EC_Base

signal jump_finished_signal
signal jump_in_midl_pos

var target_position: Vector3
var jump_time_total: float
var jump_time_passed: float
var is_jumping: bool = false
var midel_off:bool = false
var start_position: Vector3
var jump_curve:Curve
var max_height:float = 10.0

func _ready() -> void:
	jump_curve = enemy.jump_curve


func start_custom_jump(to_marker: Marker3D,new_jump_time:float):
	target_position = to_marker.global_position
	start_position = enemy.global_position
	jump_time_total = new_jump_time
	jump_time_passed = 0.0
	is_jumping = true
	await get_tree().create_timer(0.3).timeout
	%long_jump.play()

func _physics_process(delta: float) -> void:
	if not is_jumping:
		return
		
	# Прибавляем время, сколько уже летим
	jump_time_passed += delta
	
	# Считаем прогресс от 0.0 (старт) до 1.0 (приземление)
	var progress = jump_time_passed / jump_time_total
	
	if progress >= 1.0:
		# ПРИЗЕМЛИЛИСЬ! Жестко ставим в цель, чтобы не было микро-промахов
		enemy.global_position = target_position
		is_jumping = false
		midel_off = false
		jump_finished_signal.emit() # Всё, мув окончен
		return
		
	# 1. ДВИЖЕНИЕ ПО ПОЛУ (X и Z)
	# Мы просто плавно двигаем позицию от старта к финишу
	var base_pos = start_position.lerp(target_position, progress)
	
	# 2. ДВИЖЕНИЕ ВВЕРХ (Y)
	var curve_value = 0.0

	if jump_curve:
		# Берем значение из нашей кривой в инспекторе (оно будет от 0.0 до 1.0)
		curve_value = jump_curve.sample(progress)
	else:
		# Запасной вариант на случай, если забыл назначить кривую в инспекторе
		curve_value = 4.0 * progress * (1.0 - progress)

	var arc_y = curve_value * max_height
	
	# Собираем всё вместе
	enemy.global_position = Vector3(
		base_pos.x,
		base_pos.y + arc_y, # добавляем арку к стартовой высоте
		base_pos.z
	)
	
	if progress > 0.5 and !midel_off:
		midel_off = true
		jump_in_midl_pos.emit()
